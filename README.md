
Intent— An online auction platform based on blockchain would be great improvement over current auction systems.

All the online auction platforms that currently exist are based on one centralized operation. They rely on proprietary and closed software. As a result of this centralization, these platforms share the same limitations. i.e. Lack of transparency, Closed and Limited.

With the help of blockchain structure auction data and bids will be impossible to falsify. The platform will be transparent, reliable and scalable. With the help of this market anyone can place any item to auction and bidder can bid and buy items without any fraud.

Blockchain— The world of Auction is a very tedious thing to manage, no matter how well you prepare the system to work. There are many analysis which Auction is accounted for, fails to achieve its goal. Situation such as time sensitivity, entry barriers for the ones who bid, no certainty that the amount you bid is accepted, increase in the amount of bid leads to the idea of needing more secure transactions for which we implemented the concept of blockchain where every transactions is noted down. The result of the auction wants certainty of their bids, not anonymous result.

There&#39;s where we tried to introduce Blockchain to make transactions more transparent. Every transaction is trustworthy and made available to the bidders as soon as they bid, to know if their bid is accepted or rejected for the product. The transactions mainly looks after the amount and the time of the bidders, where you cannot break the block, if tried most of the connecting block would also be destroyed. This makes the transaction secure and hence its use in Auction.

Objectives— The core objectives of this system are outlined below:

1. Owner of an item announces that an item is up for sale, sets the base price and starts the timer.
2. Each bidder has a fixed amount disposable for auction in his/her wallet. Bidder can&#39;t bid more than the wallet contents.
3. The bidders place their bids in real timse and continue participating in the bidding process until the time is out.
4. Each bid is visible to other bidders real time along with the name/ID of the bidder
5. Once the time is out, the ownership of the item changes to the highest bidder and the item holds the info of the bid and ownership details.
6. After successful bid, the money from the highest bidder is transferred to the owner of the item.
7. If there is no bidder, mark the item as unsold.
8. Each participant in the ecosystem can be an owner or a bidder (not both at once).

Actors—Following are main Actors of the system:


- User : User of system may of two type Seller and Buyer/Bidder. Once seller set up product on the system will be available to all the bidders. Seller can&#39;t bid for his own product. On the other hand bidder or buyer may place bid for any available assets.
- Asset : Asset you can think of any tangible, non-tangible item that may be placed into the system. Now it&#39;s up to the buyer/bidder to bid on the asset.
- Bid: Bid on a particular product needs some criteria.

    1. Sufficient Balance. If you don&#39;t have sufficient balance you can add into.
    2. Bid should be placed inside speculative time box.

- Time Box: It is the driving factor of the system, once the time box set by the seller in the system, it continue to run to decide whether the product will be Sold or remain Unsold at the end of the time box. It also decide who wins the auction by placing highest Bid in terms of amount.

Design—Design is the most important factor to sustain in the market. You need to be scalable, adapt changes,  secured and cost effective.

Most critical part of this system is visibility to all and need to be most secured and protective for user data. Here comes the Ethereum, it will act as Public Ledger and also be irreversible in nature.

In the context of Ethereum, we define scalability as the capacity of the mainchain to improve performance (throughput, latency) as the number of users (DApps) increases, without making a difference to the users experience (gas prices, transaction times).

Proof of Authority (PoA) is a modified form of Proof of Stake (PoS) where instead of stake with the monetary value, a validator&#39;s identity performs the role of stake.In this context, identity means the correspondence between a validator&#39;s personal identification on the platform with officially issued documentation for the same person, i.e. certainty that a validator is exactly who that person represents to be.

Parity is an open source Rust implementation of Ethereum solution which helps to run Blockchain on any nodes to create a Decentralize Network of trust in the contrast of current Centralized SOA architecture. It is also a cost effective solution in terms of value, money and time.

System—The system will be relying on the backend blockchain layer, and it will communicate with the frontend JavaScript based system through JSON RPC. Each node of parity talk communicate with each other and get synced through UDP 30303.



System Flow—


System Diagram—

