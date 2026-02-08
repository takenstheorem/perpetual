// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

interface dao_direct {
  function description(uint256 _index) external view returns (string memory);
  function yeanay(uint256 _index) external view returns (uint, uint);
  function creator(uint256 _index) external view returns (address);
  function votingDeadline(uint256 _index) external view returns (uint);
}

interface IDependencyRegistryV0 {
  function getDependencyScriptCount(bytes32 dependencyNameAndVersion) external view returns (uint256);
  function getDependencyScript(bytes32 dependencyNameAndVersion, uint256 index) external view returns (string memory);
}

interface IScriptStore {
  function script() external view returns (string memory);
}

contract renderer_new {
  using Strings for uint256;

  address private constant DAO_DIRECT = 0xF3F13D6EDb1aCa14F0244e7105a327ccF41EeAea;
  address private constant DEPENDENCY_REGISTRY = 0x37861f95882ACDba2cCD84F5bFc4598e2ECDDdAF;
  bytes32 private constant P5_DEPENDENCY = bytes32("p5@1.0.0");

  error NotOwner();
  error ScriptStoreNotSet();

  address public owner;
  address public scriptStore;

  struct BuildState {
    string out;
    string firstProp;
    string lastProp;
    string thumbText;
    address firstCreator;
    uint256 lineCount;
    bool any;
  }

  struct RenderData {
    string proposalsJson;
    string firstProp;
    string lastProp;
    string thumbText;
    address firstCreator;
  }

  modifier onlyOwner() {
    if (msg.sender != owner) revert NotOwner();
    _;
  }

  constructor(address scriptStore_) {
    owner = msg.sender;
    scriptStore = scriptStore_;
  }

  function setScriptStore(address scriptStore_) external onlyOwner {
    scriptStore = scriptStore_;
  }

  function showcase(uint256 token_id) external view returns (string memory) {
    RenderData memory data = buildProposals(token_id);
    string memory image = buildImage(token_id, data.thumbText, data.firstCreator);
    string memory animation = buildAnimation(token_id, data.proposalsJson);
    return buildMetadata(token_id, data.firstProp, data.lastProp, image, animation);
  }

  function buildProposals(uint256 token_id)
    internal
    view
    returns (RenderData memory)
  {
    dao_direct proposals = dao_direct(DAO_DIRECT);
    BuildState memory st = BuildState({
      out: '[',
      firstProp: '',
      lastProp: '',
      thumbText: '',
      firstCreator: address(0),
      lineCount: 0,
      any: false
    });

    for (uint i = 1; i < 40; i++) {
      uint _index = (token_id + i - 1) % 307;
      st = processProposal(proposals, _index, st);
    }

    st.out = string(abi.encodePacked(st.out, ']'));
    return RenderData({
      proposalsJson: st.out,
      firstProp: st.firstProp,
      lastProp: st.lastProp,
      thumbText: st.thumbText,
      firstCreator: st.firstCreator
    });
  }

  function buildImage(uint256 token_id, string memory thumbText, address firstCreator)
    internal
    pure
    returns (string memory)
  {
    string memory svg = buildThumbnailSvg(token_id, thumbText, firstCreator);
    return Base64.encode(bytes(svg));
  }

  function buildAnimation(uint256 token_id, string memory proposalsJson)
    internal
    view
    returns (string memory)
  {
    string memory html = buildHTML(token_id, proposalsJson);
    return Base64.encode(bytes(html));
  }

  function buildMetadata(
    uint256 token_id,
    string memory first_prop,
    string memory last_prop,
    string memory image,
    string memory animation
  ) internal pure returns (string memory) {
    bytes memory json = abi.encodePacked(
      '{"name":"', first_prop, '/', last_prop, '"',
      ',"description":"Archival nodes of the first experiment machine. Ideas encoded in proposals and actualized by collective assent."',
      ',"attributes":[{"trait_type":"Proposal Start","value":"', first_prop, '"},',
      '{"trait_type":"Proposal End","value":"', last_prop, '"},',
      '{"trait_type":"Palette","value":"', paletteName(token_id), '"}]',
      ',"image":"data:image/svg+xml;base64,', image, '"',
      ',"animation_url":"data:text/html;base64,', animation, '"}'
    );
    return string(abi.encodePacked('data:application/json;base64,', Base64.encode(json)));
  }

  function processProposal(dao_direct proposals, uint256 _index, BuildState memory st)
    internal
    view
    returns (BuildState memory)
  {
    string memory desc = proposals.description(_index);
    bytes memory _description = bytes(desc);

    if (_description.length <= 1) {
      return st;
    }

    if (_index == 82 && _description.length > 683) {
      _description[682] = '+';
      _description[683] = '+';
    }
    if (_index == 202 && _description.length > 21) {
      _description[0] = '{';
      _description[21] = '{';
    }
    if (_index == 204 && _description.length > 0) {
      _description[0] = '{';
    }

    string memory safeDesc = escapeJSON(string(_description));
    (uint yea, uint nay) = proposals.yeanay(_index);
    address creator = proposals.creator(_index);
    uint deadline = proposals.votingDeadline(_index);

    if (st.any) {
      st.out = string(abi.encodePacked(st.out, ','));
    }

    st.out = string(
      abi.encodePacked(
        st.out,
        '{"index":', Strings.toString(_index),
        ',"description":"', safeDesc,
        '","yea":"', Strings.toString(yea),
        '","nay":"', Strings.toString(nay),
        '","creator":"0x', toAsciiString(creator),
        '","deadline":', Strings.toString(deadline),
        '}'
      )
    );

    if (!st.any) {
      st.firstProp = Strings.toString(_index);
    }
    st.lastProp = Strings.toString(_index);
    st.any = true;

    if (st.lineCount < 18) {
      string memory thumbLine = buildThumbLine(_index, string(_description));
      st.thumbText = appendTspan(st.thumbText, thumbLine, st.lineCount == 0);
      st.lineCount += 1;
    }
    if (st.firstCreator == address(0)) {
      st.firstCreator = creator;
    }

    return st;
  }

  function paletteName(uint256 token_id) internal pure returns (string memory) {
    uint256 mode = token_id % 4;
    if (mode == 0) return "Black & White";
    if (mode == 1) return "Creator Color";
    if (mode == 2) return "Random Color";
    return "Dark Mode";
  }

  function buildThumbnailSvg(uint256 token_id, string memory thumbText, address firstCreator)
    internal
    pure
    returns (string memory)
  {
    (string memory bg, string memory fg) = paletteColors(token_id, firstCreator);
    if (bytes(thumbText).length == 0) {
      thumbText = '<tspan x="40" dy="0">No proposals</tspan>';
    }
    return string(
      abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="1000" viewBox="0 0 1000 1000">',
        '<rect width="1000" height="1000" fill="#', bg, '"/>',
        '<text x="40" y="70" fill="#', fg, '" font-family="Courier New, monospace" font-size="44">',
        thumbText,
        '</text></svg>'
      )
    );
  }

  function paletteColors(uint256 token_id, address firstCreator)
    internal
    pure
    returns (string memory, string memory)
  {
    uint256 mode = token_id % 4;
    if (mode == 3) {
      return ("1f1a18", "e7e0d5");
    }
    string memory bg = "f7f7f4";
    if (mode == 0) return (bg, "111111");
    if (mode == 1) return (bg, creatorColor(firstCreator));
    return (bg, randomColorFromToken(token_id));
  }

  function creatorColor(address creator) internal pure returns (string memory) {
    if (creator == address(0)) return "444444";
    bytes20 b = bytes20(creator);
    uint8 r = uint8(b[0]) ^ uint8(b[3]);
    uint8 g = uint8(b[1]) ^ uint8(b[4]);
    uint8 bl = uint8(b[2]) ^ uint8(b[5]);
    return string(abi.encodePacked(toHexByte(r), toHexByte(g), toHexByte(bl)));
  }

  function randomColorFromToken(uint256 token_id) internal pure returns (string memory) {
    bytes32 h = keccak256(abi.encodePacked(token_id));
    uint8 r = 50 + (uint8(h[0]) % 180);
    uint8 g = 50 + (uint8(h[1]) % 180);
    uint8 b = 50 + (uint8(h[2]) % 180);
    return string(abi.encodePacked(toHexByte(r), toHexByte(g), toHexByte(b)));
  }

  function toHexByte(uint8 b) internal pure returns (string memory) {
    bytes memory out = new bytes(2);
    out[0] = char(bytes1(b >> 4));
    out[1] = char(bytes1(b & 0x0f));
    return string(out);
  }

  function buildThumbLine(uint256 index, string memory desc) internal pure returns (string memory) {
    string memory clean = normalizeWhitespace(desc);
    string memory truncated = truncateBytes(clean, 80);
    string memory line = string(abi.encodePacked('#', Strings.toString(index), ' ', truncated));
    return escapeXML(line);
  }

  function appendTspan(string memory acc, string memory line, bool first) internal pure returns (string memory) {
    if (first) {
      return string(abi.encodePacked(acc, '<tspan x="40" dy="0">', line, '</tspan>'));
    }
    return string(abi.encodePacked(acc, '<tspan x="40" dy="52">', line, '</tspan>'));
  }

  function normalizeWhitespace(string memory str) internal pure returns (string memory) {
    bytes memory b = bytes(str);
    bytes memory out = new bytes(b.length);
    for (uint i = 0; i < b.length; i++) {
      bytes1 c = b[i];
      if (c == 0x0a || c == 0x0d || c == 0x09) {
        out[i] = 0x20;
      } else {
        out[i] = c;
      }
    }
    return string(out);
  }

  function truncateBytes(string memory str, uint256 maxLen) internal pure returns (string memory) {
    bytes memory b = bytes(str);
    if (b.length <= maxLen) return str;
    bytes memory out = new bytes(maxLen);
    for (uint i = 0; i < maxLen; i++) {
      out[i] = b[i];
    }
    return string(out);
  }

  function escapeXML(string memory str) internal pure returns (string memory) {
    bytes memory b = bytes(str);
    bytes memory out;
    for (uint i = 0; i < b.length; i++) {
      bytes1 c = b[i];
      if (c == '&') {
        out = abi.encodePacked(out, '&amp;');
      } else if (c == '<') {
        out = abi.encodePacked(out, '&lt;');
      } else if (c == '>') {
        out = abi.encodePacked(out, '&gt;');
      } else if (c == '"') {
        out = abi.encodePacked(out, '&quot;');
      } else if (c == "'") {
        out = abi.encodePacked(out, '&#39;');
      } else if (uint8(c) < 0x20) {
        out = abi.encodePacked(out, ' ');
      } else {
        out = abi.encodePacked(out, c);
      }
    }
    return string(out);
  }

  function buildHTML(uint256 token_id, string memory proposalsJson) internal view returns (string memory) {
    string memory p5 = loadP5();
    string memory sketchB64 = loadSketch();
    string memory proposalsB64 = Base64.encode(bytes(proposalsJson));
    return string(
      abi.encodePacked(
        '<!doctype html><html><head><meta charset="utf-8">',
        '<meta name="viewport" content="width=device-width, initial-scale=1">',
        '<style>html,body{margin:0;padding:0;width:100%;height:100%;overflow:hidden;background:#5a4028;}canvas{display:block;}</style>',
        '</head><body>',
        '<script>',
        'var proposalsB64="', proposalsB64, '";',
        'function cleanB64(s){return (s||"").replace(/\\s+/g,"");}',
        'function parseProposals(){',
        '  var raw="";',
        '  try{raw=atob(cleanB64(proposalsB64));}catch(e){return [];}', 
        '  try{return JSON.parse(raw);}catch(e){',
        '    var cleaned=raw.replace(/[\\u0000-\\u001F]/g," ");',
        '    try{return JSON.parse(cleaned);}catch(e2){return [];}', 
        '  }',
        '}',
        'var PROPOSALS=parseProposals();',
        'window.PROPOSALS=PROPOSALS;',
        'window.DATA_SOURCE=PROPOSALS;',
        'var TOKEN_ID="', token_id.toString(), '";',
        'window.TOKEN_ID=TOKEN_ID;',
        '</script>',
        '<script>(function(){',
        'var p5gz="', p5, '";',
        'var sketchB64="', sketchB64, '";',
        'function cleanB64(s){return (s||"").replace(/\\s+/g,"");}',
        'function inject(code){var el=document.createElement("script");el.text=code;document.body.appendChild(el);}',
        'function injectSketch(){try{inject(atob(cleanB64(sketchB64)));}catch(e){}}',
        'function injectP5(code){inject(code);injectSketch();}',
        'function gunzipBase64(b64){',
        '  if(typeof DecompressionStream==="undefined") return Promise.reject(new Error("no-gzip"));',
        '  var clean=cleanB64(b64);',
        '  return fetch("data:application/octet-stream;base64,"+clean)',
        '    .then(function(r){return r.arrayBuffer();})',
        '    .then(function(buf){',
        '      var ds=new DecompressionStream("gzip");',
        '      return new Response(new Blob([buf]).stream().pipeThrough(ds)).text();',
        '    });',
        '}',
        'var cleanP5=cleanB64(p5gz);',
        'if(cleanP5 && cleanP5.indexOf("H4sI")===0){',
        '  gunzipBase64(cleanP5).then(injectP5).catch(function(){injectP5(p5gz);});',
        '}else{',
        '  injectP5(p5gz);',
        '}',
        '}());</script>',
        '</body></html>'
      )
    );
  }

  function loadP5() internal view returns (string memory) {
    IDependencyRegistryV0 registry = IDependencyRegistryV0(DEPENDENCY_REGISTRY);
    uint256 count = registry.getDependencyScriptCount(P5_DEPENDENCY);
    string memory out = '';
    for (uint256 i = 0; i < count; i++) {
      out = string(abi.encodePacked(out, registry.getDependencyScript(P5_DEPENDENCY, i)));
    }
    return out;
  }

  function loadSketch() internal view returns (string memory) {
    address store = scriptStore;
    if (store == address(0)) revert ScriptStoreNotSet();
    return IScriptStore(store).script();
  }

  function escapeJSON(string memory str) internal pure returns (string memory) {
    bytes memory b = bytes(str);
    bytes memory out;

    for (uint i = 0; i < b.length; i++) {
      bytes1 c = b[i];
      if (c == '"') {
        out = abi.encodePacked(out, '\\"');
      } else if (c == '\\') {
        out = abi.encodePacked(out, '\\\\');
      } else if (c == '\n') {
        out = abi.encodePacked(out, '\\n');
      } else if (c == '\r') {
        out = abi.encodePacked(out, '\\r');
      } else if (c == '\t') {
        out = abi.encodePacked(out, '\\t');
      } else if (c == bytes1(0x08)) {
        out = abi.encodePacked(out, '\\u0008');
      } else if (c == bytes1(0x0c)) {
        out = abi.encodePacked(out, '\\u000c');
      } else if (c == '<') {
        out = abi.encodePacked(out, '\\u003c');
      } else if (uint8(c) < 0x20) {
        out = abi.encodePacked(out, escapeLowAscii(c));
      } else {
        out = abi.encodePacked(out, c);
      }
    }

    return string(out);
  }

  function escapeLowAscii(bytes1 b) internal pure returns (string memory) {
    uint8 v = uint8(b);
    bytes1 hi = char(bytes1(v / 16));
    bytes1 lo = char(bytes1(v % 16));
    return string(abi.encodePacked('\\u00', hi, lo));
  }

  function toAsciiString(address x) internal pure returns (string memory) {
    bytes memory s = new bytes(40);
    for (uint i = 0; i < 20; i++) {
      bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8 * (19 - i)))));
      bytes1 hi = bytes1(uint8(b) / 16);
      bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
      s[2 * i] = char(hi);
      s[2 * i + 1] = char(lo);
    }
    return string(s);
  }

  function char(bytes1 b) internal pure returns (bytes1 c) {
    if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
    return bytes1(uint8(b) + 0x57);
  }
}
