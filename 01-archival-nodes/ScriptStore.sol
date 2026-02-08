// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract ScriptStore {
  error NotOwner();

  address public owner;
  string private _scriptBase64;

  modifier onlyOwner() {
    if (msg.sender != owner) revert NotOwner();
    _;
  }

  constructor(string memory scriptBase64_) {
    owner = msg.sender;
    _scriptBase64 = scriptBase64_;
  }

  function script() external view returns (string memory) {
    return _scriptBase64;
  }

  function setScript(string memory scriptBase64_) external onlyOwner {
    _scriptBase64 = scriptBase64_;
  }
}
