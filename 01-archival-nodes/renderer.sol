// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

interface dao_direct {
  function description(uint256 _index) external view returns (bytes memory);
  function yeanay(uint256 _index) external view returns (uint, uint);
  function creator(uint256 _index) external view returns (address);
  function votingDeadline(uint256 _index) external view returns (uint);
}

contract anfem {

  function make_rows(uint token_id) public pure returns (string memory) {
    uint f=(100*(token_id%307))/307;
    uint nrows = 40;
    string memory path = '';
    for (uint i=0;i<nrows-1;i++) {
        path = string(abi.encodePacked(path,' M 50 ',
        Strings.toString((900*i)/(nrows-1)+(100-f)),' L 950 ',
        Strings.toString((900*i)/(nrows-1)+f)));
    }
    return(path);
  }

  function showcase(uint256 token_id) external view returns (string memory) {

    dao_direct proposals = dao_direct(0xF3F13D6EDb1aCa14F0244e7105a327ccF41EeAea);    
    string memory first_prop = '';
    string memory last_prop = '';
    string memory img = '';
    uint lns = 0;

    for (uint i=1;i<40;i++) {
        uint _index = (token_id + i - 1) % 307;
        bytes memory _description = bytes(proposals.description(_index));

        if (_description.length>1) {
            address _creator = proposals.creator(_index);      
            (uint _yea, uint _nay) = proposals.yeanay(_index);
            uint p = (100*_yea)/(_yea + _nay + 1);
            string memory alpha = 'ff';
            if (p<50) {
                alpha = '50';
            } 
            string memory col = cl(0, _creator, alpha);
            if (_index == 82) {
                _description[682]='+';
                _description[683]='+';
            }
            if (_index==202) {
                _description[0]='{';
                _description[21]='{';
            }
            if (_index==204) {
                _description[0]='{';
            }
            img = string(abi.encodePacked(img,'<tspan style="stroke:white!important;fill:#',col,'!important;dominant-baseline:middle;">',_description,'</tspan> '));
            lns+=_description.length;
            if (bytes(first_prop).length==0){first_prop=Strings.toString(_index);}
            last_prop=Strings.toString(_index);
        }
    }
    img = string(abi.encodePacked('<path d="',make_rows(token_id),
        '" id="p" /><text><textPath href="#p" style="text-transform:lowercase;letter-spacing:-10pt;font-size:',
        Strings.toString((800*40)/lns+50),
        'pt;dominant-baseline:middle;font-family:courier;">',img));

    img = string(abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" height="1000" width="1000" viewBox="0 0 1000 1000"><rect x="0" y="0" width="1000" height="1000" fill="black" />',img));
    img = Base64.encode(abi.encodePacked(img,'################################################################</textPath></text></svg>'));

    bytes memory json = abi.encodePacked('{"name":"Archive #',Strings.toString(token_id),'"',
      ',"description":"Archival nodes of the first experiment machine. Ideas encoded in proposals and actualized by collective assent. Deterministic layout, linking symbols and submissions. All color, position variation mapped to chain data (except archive cursor, determined by token ID)."',
      ',"attributes":[{"trait_type":"Proposal Start","value":"',first_prop,'"},{"trait_type":"Proposal End","value":"',last_prop,'"}]',
      ',"image":"data:image/svg+xml;base64,',img,
      '"}');
    return string(abi.encodePacked('data:application/json;base64,',Base64.encode(json)));        
  }

  function cl(uint256 shift, address base, string memory alpha) private pure returns (string memory) {        
    return string(abi.encodePacked(subString(toAsciiString(base), shift, shift+6),alpha));    
  }

  // adapted from tkeber solution: https://ethereum.stackexchange.com/a/8447
  function toAsciiString(address x) internal pure returns (string memory) {
    bytes memory s = new bytes(40);
    for (uint i = 0; i < 20; i++) {
        bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
        bytes1 hi = bytes1(uint8(b) / 16);
        bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
        s[2*i] = char(hi);
        s[2*i+1] = char(lo);            
    }
    return string(s);
  }

  function char(bytes1 b) internal pure returns (bytes1 c) {
    if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
    else return bytes1(uint8(b) + 0x57);
  }    
  
  // adapted from t-nicci solution https://ethereum.stackexchange.com/a/31470
  function subString(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
    bytes memory strBytes = bytes(str);
    bytes memory result = new bytes(endIndex-startIndex);
    for(uint i = startIndex; i < endIndex; i++) {
      result[i-startIndex] = strBytes[i];
    }
    return string(result);
  }      

}
