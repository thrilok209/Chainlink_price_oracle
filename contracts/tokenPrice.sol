pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

contract GetPrice is ChainlinkClient {
  uint256 constant private LinkAmt = 1 * LINK;

  uint256 public tokenPrice;

  constructor() public {
    setPublicChainlinkToken();
  }

  function requestPair(
    address _oracle,
    string memory _jobId,
    string memory _token,
    string memory _currency
  ) public
  {
    Chainlink.Request memory req = buildChainlinkRequest(stringToBytes32(_jobId), address(this), this.fulfillPrice.selector);
    req.add("coin", _token);
    req.add("market", _currency);
    req.addInt("times", 100);
    sendChainlinkRequestTo(_oracle, req, LinkAmt);
  }

  function fulfillPrice(bytes32 _requestId, uint256 _price)
    public
    recordChainlinkFulfillment(_requestId)
  {
    tokenPrice = _price;
  }

  function withdraw() public {
    LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
    link.transfer(msg.sender, link.balanceOf(address(this)));
  }

  function stringToBytes32(string memory source) private pure returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
      return 0x0;
    }
    // solium-disable-next-line security/no-inline-assembly
    assembly {
      result := mload(add(source, 32))
    }
  }
}