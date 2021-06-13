pragma solidity ^0.4.0;

contract PowerProduction{

	address private administrator;

	struct Client
	{
		string cName;
		string cAddress;
		int256 produceAmt;
		uint256 totalProduceAmt;
		uint256 consumeAmt;
		uint256 totalConsumeAmt;
		bool validProducer;
		bool validConsumer;
		string info;
	}


	mapping(address => Client)client;
	constructor() public
	{
		administrator = msg.sender;
	}


	function authorisation (address addr , string name , string cons_address , bool isValidProducer , bool isValidConsumer) public 
	{
		require(msg.sender == administrator);
		client[addr].cName = name;
		client[addr].cAddress = cons_address ; 
		client[addr].produceAmt = 0;
		client[addr].totalProduceAmt = 0;
		client[addr].consumeAmt = 0;
		client[addr].totalConsumeAmt = 0;
		client[addr].validProducer = isValidProducer;
		client[addr].validConsumer = isValidConsumer;
		client[addr].info="";		
	}

	function Production(uint256 value) public
	{
		if(!client[msg.sender].validProducer)
			return;
        
		client[msg.sender].produceAmt = client[msg.sender].produceAmt + (int256)(value) ;
		client[msg.sender].totalProduceAmt = client[msg.sender].totalProduceAmt + value ;
	}

	function Transfer(address soldTo , uint amountNeed) public
	{
		require(client[msg.sender].validProducer) ; 
		require(client[soldTo].validConsumer) ;
		require(client[soldTo].consumeAmt < client[soldTo].consumeAmt + amountNeed);
		client[msg.sender].produceAmt = client[msg.sender].produceAmt - (int256)(amountNeed);
		client[soldTo].consumeAmt = client[soldTo].consumeAmt + amountNeed ;
	}

	function consumeAmount(uint256 value) public
	{
		require(client[msg.sender].validConsumer);
		require(client[msg.sender].consumeAmt >= value);
		client[msg.sender].consumeAmt  =client[msg.sender].consumeAmt- value;
		client[msg.sender].totalConsumeAmt  = client[msg.sender].totalConsumeAmt + value ;

	}

	function PowerDispatch (address addr , string information) public
	{
		require(msg.sender == administrator) ;
		client[addr].info = information ;
	}

	function GetUsedOfSelf() public constant returns(uint value)
	{
		return (client[msg.sender].consumeAmt);

	}

	function GetTotalUsedOfSomeone(address addr) public constant returns(uint256 value)
	{
		if(msg.sender == addr || msg.sender == administrator)
			return (client[addr].totalConsumeAmt);

	}

	function GetProduction() public constant returns(int256 value)
	{
		return(client[msg.sender].produceAmt);
	}

	function GetTotalGeneration(address addr) public constant returns(uint256 value)
	{
		if(msg.sender == addr || msg.sender == administrator)
			return (client[addr].totalProduceAmt);

	}

	function GetInformation() public constant returns(string information)
	{
		return (client[msg.sender].info);
	}


}