// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/Base64.sol";

// borrowing from 2015: https://etherscan.io/address/0x1a6184cd4c5bea62b0116de7962ee7315b7bcbce#code
contract DateTime {

  struct _DateTime {
    uint16 year;
    uint8 month;
    uint8 day;
    uint8 hour;
    uint8 minute;
    uint8 second;
    uint8 weekday;
  }

  uint constant DAY_IN_SECONDS = 86400;
  uint constant YEAR_IN_SECONDS = 31536000;
  uint constant LEAP_YEAR_IN_SECONDS = 31622400;

  uint constant HOUR_IN_SECONDS = 3600;
  uint constant MINUTE_IN_SECONDS = 60;

  uint16 constant ORIGIN_YEAR = 1970;

  function isLeapYear(uint16 year) public pure returns (bool) {
    if (year % 4 != 0) {
      return false;
    }
    if (year % 100 != 0) {
      return true;
    }
    if (year % 400 != 0) {
      return false;
    }
    return true;
  }

  function leapYearsBefore(uint year) public pure returns (uint) {
    year -= 1;
    return year / 4 - year / 100 + year / 400;
  }

  function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
      return 31;
    }
    else if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    }
    else if (isLeapYear(year)) {
      return 29;
    }
    else {
      return 28;
    }
  }

  function parseTimestamp(uint timestamp) public pure returns (_DateTime memory dt) {
    uint secondsAccountedFor = 0;
    uint buf;
    uint8 i;

    dt.year = ORIGIN_YEAR;

    // Year
    while (true) {
      if (isLeapYear(dt.year)) {
        buf = LEAP_YEAR_IN_SECONDS;
      }
      else {
        buf = YEAR_IN_SECONDS;
      }

      if (secondsAccountedFor + buf > timestamp) {
        break;
      }
      dt.year += 1;
      secondsAccountedFor += buf;
    }

    // Month
    uint8[12] memory monthDayCounts;
    monthDayCounts[0] = 31;
    if (isLeapYear(dt.year)) {
      monthDayCounts[1] = 29;
    }
    else {
            monthDayCounts[1] = 28;
    }
    monthDayCounts[2] = 31;
    monthDayCounts[3] = 30;
    monthDayCounts[4] = 31;
    monthDayCounts[5] = 30;
    monthDayCounts[6] = 31;
    monthDayCounts[7] = 31;
    monthDayCounts[8] = 30;
    monthDayCounts[9] = 31;
    monthDayCounts[10] = 30;
    monthDayCounts[11] = 31;

    uint secondsInMonth;
    for (i = 0; i < monthDayCounts.length; i++) {
      secondsInMonth = DAY_IN_SECONDS * monthDayCounts[i];
      if (secondsInMonth + secondsAccountedFor > timestamp) {
        dt.month = i + 1;
        break;
      }
      secondsAccountedFor += secondsInMonth;
    }

    // Day
    for (i = 0; i < monthDayCounts[dt.month - 1]; i++) {
      if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
        dt.day = i + 1;
        break;
      }
      secondsAccountedFor += DAY_IN_SECONDS;
    }

    // Hour
    for (i = 0; i < 24; i++) {
      if (HOUR_IN_SECONDS + secondsAccountedFor > timestamp) {
        dt.hour = i;
        break;
      }
      secondsAccountedFor += HOUR_IN_SECONDS;
    }

    // Minute
    for (i = 0; i < 60; i++) {
      if (MINUTE_IN_SECONDS + secondsAccountedFor > timestamp) {
        dt.minute = i;
        break;
      }
      secondsAccountedFor += MINUTE_IN_SECONDS;
    }

    if (timestamp - secondsAccountedFor > 60) {
      //__throw();
    }

    // Second
    dt.second = uint8(timestamp - secondsAccountedFor);

    // Day of week.
    buf = timestamp / DAY_IN_SECONDS;
    dt.weekday = uint8((buf + 3) % 7);
  }

}

contract hashFilter is DateTime {

  function t(uint256 d, uint256 token_id, bytes1 val) private pure returns (bytes1) {
    uint256 fac = rvl(d,token_id*d)%2 + 1;
    return bytes1(uint8(uint8(val)/fac));
  }

  function rvl(uint256 i, uint256 seed) private pure returns (uint256) {
    bytes20 baseContent = bytes20(keccak256(abi.encodePacked(seed)));
    return uint256(uint8(baseContent[i]));
  }

  function pixel_avg(uint256 v, uint256 bn) private view returns (bytes1) {
    // smooth by block
    uint8 col_val = uint8(blockhash(bn-1)[v%32])/5+
      uint8(blockhash(bn-2)[v%32])/5+
      uint8(blockhash(bn-3)[v%32])/5+
      uint8(blockhash(bn-4)[v%32])/5+
      uint8(blockhash(bn-5)[v%32])/5;
    if (col_val<100) {
      col_val = 0;
    } else {
      col_val = 255;
    }
    bytes1 result = bytes1(col_val);
    return result;
  }

  function bmp(uint256 token_id, uint256 bn) public view returns (string memory) {

    // 10x10 pixels * 3 bytes per pixel + padding for each row
    bytes memory pixel_data = new bytes(320); 

    // pixels + header
    bytes memory bmp_data = new bytes(374);

    // requisite materials including compression, dimensions, ncols, etc.:
    bytes memory bmp_header = new bytes(54);
    uint8[54] memory header = [
      0x42, 0x4D, 0x76, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x36, 0x00, 0x00, 0x00, 0x28, 0x00, 0x00, 0x00,
      0x0A, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00,
      0x01, 0x00, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x40, 0x01, 0x00, 0x00, 0x13, 0x0B, 0x00, 0x00,
      0x13, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00
    ];

    // encode bmp header 
    for (uint256 i = 0; i < 54; i++) {
      bmp_header[i] = bytes1(header[i]);
    }

    // render pixels
    for (uint256 i = 0; i < 100; i++) {
      uint256 index = (i/10)*32+(i%10)*3;      
      uint256 fac = 0;
      if (token_id%32==0){fac = i;} // avoid whole colors, shift
      pixel_data[index] = t(1,token_id,pixel_avg(token_id*i+fac,bn));
      pixel_data[index + 1] = t(2,token_id,pixel_avg(token_id*i*2+fac,bn));
      pixel_data[index + 2] = t(3,token_id,pixel_avg(token_id*i*3+fac,bn));
    }

    for (uint256 i = 0; i < 54; i++) {
      bmp_data[i] = bmp_header[i];
    }
    for (uint256 i = 0; i < 320; i++) {
      bmp_data[i + 54] = pixel_data[i];
    }

    string memory bmp_encoded = Base64.encode(bmp_data);

    return string(abi.encodePacked("data:image/bmp;base64,", bmp_encoded));
  }

  function dateString(uint256 ts) public pure returns (string memory) {
    string memory result = Strings.toString(uint256(parseTimestamp(ts).year));
    result = string(abi.encodePacked(result,'.',Strings.toString(uint256(parseTimestamp(ts).month))));
    result = string(abi.encodePacked(result,'.',Strings.toString(uint256(parseTimestamp(ts).day))));
    result = string(abi.encodePacked(result,'.',Strings.toString(uint256(parseTimestamp(ts).hour))));
    result = string(abi.encodePacked(result,'.',Strings.toString(uint256(parseTimestamp(ts).minute))));
    result = string(abi.encodePacked(result,'.',Strings.toString(uint256(parseTimestamp(ts).second))));
    return result;
  }

  function showcase(uint256 token_id) public view returns (string memory) {
    string memory img_front = '<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" viewBox="0 0 1000 1000" preserveAspectRatio="xMidYMid meet"><defs><pattern id="bgp" patternUnits="userSpaceOnUse" width="1000" height="1000"><image href="';
    
    string memory text1 = string(abi.encodePacked('<text x="10" y="990" font-family="Arial" font-size="7pt" fill="#ffffff44">',Strings.toHexString(uint256(blockhash(block.number-1))),' | '));
    string memory text2 = string(abi.encodePacked(Strings.toString(block.number),' | ',dateString(block.timestamp),'</text>'));

    string memory img_back = '" x="0" y="0" width="1000" height="1000" preserveAspectRatio="none" style="image-rendering: crisp-edges;" /></pattern></defs><rect x="0" y="0" width="100%" height="100%" fill="black"/><rect x="0" y="0" width="100%" height="100%" fill="url(#bgp)"  style="image-rendering: pixellated;"/>';    
    string memory img = Base64.encode(abi.encodePacked(img_front,bmp(token_id,block.number),img_back,text1,text2,'</svg>'));
    
    string memory idt = Strings.toHexString(token_id);
    bytes memory json = abi.encodePacked('{"name":"Filtered | ',idt,'"',
        ',"description":"Pattern from smoothed stochastic; determined and random."',
        ',"attributes":[{"trait_type":"Renderer","value":"3"}]',
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

}
