// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

struct Proposal {
  uint recipient;
  uint amount;
  string description;
  uint votingDeadline;
  bool open;
  bool proposalPassed;
  bytes32 proposalHash;
  uint proposalDeposit;
  bool newCurator;
  uint yea;
  uint nay;
  address creator;
}

contract dao_info {
  Proposal[] public proposals;
}
 
contract dao_direct {

  dao_info dao = dao_info(0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413);

  function description(uint256 _index) public view returns (string memory) {
    (,,string memory _description,,,,,,,,,) = dao.proposals(_index);
    return _description;
  }

  function yeanay(uint256 _index) public view returns (uint, uint) {
    (,,,,,,,,,uint yea,uint nay,) = dao.proposals(_index);
    return (yea, nay);
  }

  function creator(uint256 _index) public view returns (address) {
    (,,,,,,,,,,,address _creator) = dao.proposals(_index);
    return _creator;
  }

  function votingDeadline(uint256 _index) public view returns (uint) {
    (,,,uint _votingDeadline,,,,,,,,) = dao.proposals(_index);
    return _votingDeadline;
  }

  function proposalPassed(uint256 _index) public view returns (bool) {
    (,,,,,bool _proposalPassed,,,,,,) = dao.proposals(_index);
    return _proposalPassed;
  }

}
