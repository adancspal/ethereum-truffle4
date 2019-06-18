pragma solidity ^0.5.8;

// import 
import "./Ownable.sol"; 

contract ChainList is Ownable {
	// custom types
	struct Article {
		uint id; 
		address payable seller; 
		address buyer; 
		string name; 
		string description; 
		uint256 price; // in Wei
	}

	// state variables
	// address owner; 
	// Commented because it´s in the parent contract

	mapping (uint => Article) public articles; 
	uint articleCounter; 

	// events
	event LogSellArticle(
			uint indexed _id, 
			address indexed _seller, 
			string _name, 
			uint256 _price
		); 

	event LogBuyArticle(
			uint indexed _id, 
			address indexed _seller, 
			address indexed _buyer, 
			string _name, 
			uint256 _price
		); 

	// modifiers
	/*modifier onlyOwner() {
		require(msg.sender == owner); 
		_; // placeholder that represents the code of the function that the modifier is applied to
		// These modifiers are a kind of an "Aspect" implementation
	}*/
	// Commented because it's in the parent contract

	// constructor
	// function ChainList() public {
	//	owner = msg.sender; 
	// }
	// Commented because it's in the parent contract
	

	// deactivate the contract
	function kill() public onlyOwner {
		// only allow the contract owner
		// require(msg.sender == owner); 
		// Done by the modifier

		selfdestruct(owner); 
	}

	// sell an article
	function sellArticle(string memory _name, string memory _description, uint256 _price) public {
		// increment the article counter
		articleCounter++; 

		articles[articleCounter] = Article(
				articleCounter, // key in the mapping 
				msg.sender, 
				address(0), 
				_name, 
				_description, 
				_price
			); 

		emit LogSellArticle(articleCounter, msg.sender, _name, _price); 
	}

	// get number of articles in the contract
	function getNumberOfArticles() public view returns (uint) {
		return articleCounter; 
	}

	// get articles ids for sale
	function getArticlesForSale() public view returns (uint[] memory) {
		// prepare output array
		uint[] memory articleIds = new uint[](articleCounter); 

		uint numberOfArticlesForSale = 0; 

		// iterate over articles
		for(uint i = 1; i <= articleCounter; i++) {
			// keep the id if still for sale
			if (articles[i].buyer == address(0)) {
				articleIds[numberOfArticlesForSale] = articles[i].id; 
				numberOfArticlesForSale++; 
			}
		}

		// copy the ArticleIds array into a smaller forSale array
		uint[] memory forSale = new uint[](numberOfArticlesForSale); 
		for (uint j = 0; j < numberOfArticlesForSale; j++) {
			forSale[j] = articleIds[j]; 
		}

		return forSale; 
	}

	function buyArticle(uint _id) payable public {
		// we check whether there is an article to sell
		require(articleCounter > 0); // 0x0 parece equivaler a NULL

		// check that the article exists
		require(_id > 0 && _id <= articleCounter); 

		// we retrieve the article from the mapping
		Article storage article = articles[_id]; 

		// we check that the article has not been sold yet
		require(article.buyer == address(0)); 

		// we don´t allow the seller to buy its own article
		require(msg.sender != article.seller); 

		// we check that the value sent corresponds to the price of the article
		require(msg.value == article.price); 

		// keep track of the buyer´s information
		article.buyer = msg.sender; 

		// the buyer can pay the seller
		article.seller.transfer(msg.value); 

		// trigger the event
		emit LogBuyArticle(_id, article.seller, article.buyer, article.name, article.price); 
	}
}