// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// to 0x00E6F27559fB756e2DCf04D82A880AA1A8611410

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

interface word {
  function getWord(uint256 id) external view returns (string memory);
  function ownerOf(uint256 id) external view returns (address);
}

contract composed {

  uint256[][] public arrs;
  
  address public the_owner;
  address public wordContract = 0xAc1AEe5027FCC98d40a26588aC0841a44f53A8Fe;

  function make_txt(string memory w, uint256 l) public pure returns (string memory) {
    uint256 y=82*(l-1)+50;
    uint256 x=25+10*l;
    string memory color = '#ffffff';
    if (bytes(w).length != l) {
      color = '#ff0000';
    }
    return(string(abi.encodePacked('<text x="',Strings.toString(x),'" y="',Strings.toString(y),
      '" fill="',color,'">',w,'</text>')));
  }

  function comp(uint256 v1, uint256 v2, uint256 typ) public pure returns (uint256) {
    if (v1>v2 && typ==0){return(1);} 
    if (v1==v2 && typ==1){return(1);} 
    return 0;
  }

  function rand(uint256 token_id, uint256 seed, uint256 g) public pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(token_id,seed)))%g;
  }

  function get_word(uint256 l, uint256 token_id) public view returns (uint256) {
    uint256 b = 5;
    uint256 c = 2;
    if (l==1 || l==12) {b=1; c=0;}
    if (l==2 || l==3) {b=2+18*comp(l,3,1);c=100;}
    else if (l>3 && l<9) {b=4+comp(l,6,0); c=4-comp(l,5,0);}
    return arrs[l-1][rand(token_id,l,arrs[l-1].length)] + b*rand(token_id,l+42,c+1);    
  }

  function showcase(uint256 token_id) public view returns (string memory) {
    string memory img = '<svg xmlns="http://www.w3.org/2000/svg" height="1000" width="1000" viewBox="0 0 1000 1000"><rect x="0" y="0" width="1000" height="1000" fill="black" /><style>text{dominant-baseline:middle;font-family:courier;letter-spacing:3px;font-size:60pt;font-weight:bold;text-transform:uppercase;}</style>';
    word w = word(wordContract); 
    uint256 departs = 0;
    uint256 sums = 0;
    string memory w_l = '';
    string memory lines = '';
    for (uint256 l=1; l<13; l++) {
      w_l = w.getWord(get_word(l,token_id)-1); 
      img = string(abi.encodePacked(img,make_txt(w_l, l)));
      sums += bytes(w_l).length;
      lines = string(abi.encodePacked(lines,'{"trait_type":"line ',Strings.toString(l),'","value":"',w_l,'"}'));
      if (l<12) {
        lines = string(abi.encodePacked(lines,','));
      }
      if (bytes(w_l).length != l) {
        departs += 1;
      }      
    }
    img = Base64.encode(abi.encodePacked(img,'</svg>'));

    string memory shift_rhopalic = 'false';
    string memory rhopalic = 'false';
    if (sums == 78 && departs > 0) { shift_rhopalic='true'; }
    if (departs == 0) { rhopalic='true'; }
    bytes32 h = keccak256(abi.encodePacked(lines));
    string memory idt = subString(string(abi.encodePacked(Strings.toHexString(uint(h)))),0,10);
    bytes memory json = abi.encodePacked('{"name":"compose[d] / ',idt,'"',
      ',"description":"Generator function, curious juxtapositions of human divergences; composed positions on path to theoretical infinity."',
      ',"attributes":[{"trait_type":"Renderer","value":"2"},{"trait_type":"Rhopalic","value":"',rhopalic,
      '"},{"trait_type":"Shift Rhopalic","value":"',shift_rhopalic,
      '"},{"trait_type":"Divergences","value":',Strings.toString(departs),'},',lines,']',
      ',"image":"data:image/svg+xml;base64,',img,
      '"}');
    return string(abi.encodePacked('data:application/json;base64,',Base64.encode(json)));  
  }

  function subString(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
      bytes memory strBytes = bytes(str);
      bytes memory result = new bytes(endIndex-startIndex);
      for(uint i = startIndex; i < endIndex; i++) {
          result[i-startIndex] = strBytes[i];
      }
      return string(result);
  }    

  constructor() {
    the_owner = msg.sender;
    arrs.push([2,6,10,16,19,21]);
    arrs.push([3250,3257]);
    arrs.push([1664]);
    arrs.push([346,643,800,3446,3687,4206,4336,4437,4776,4930]);
    arrs.push([7156,7831,8072,8050,9317,10479,12194,13457,14968,14970]);
    arrs.push([6163,8806,9945,10760,11378,12608,15227,16383,19506]);
    arrs.push([4232,8631,10600,11531,12670,13808,14999,15438,17971]);
    arrs.push([18705,19743,18020,16599,14800,11629,11342,3943,14948]);
    arrs.push([587,4636,4689,4865,6424,7629,8532,8774,10714,11549,13013,13759,14198,14769,18962,19479]);
    arrs.push([4593,4971,6125,8659,9938,10611,12121,12810,15208,17652,19200,19279,19706]);
    arrs.push([12060,12115,977,4825,7569,9369,13831,15763,15981,19024,19615]); 
    arrs.push([546,866,6718,7011,7014,7520,8917,9381,10137,10143,11005,11759,13587,13989,14020,17080,17817,18479,18995,19785,14770]);
  }

}

