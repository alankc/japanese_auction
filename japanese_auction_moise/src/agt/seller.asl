//************************
//****** SELLER **********
//************************

//Initial goals
!register.
//Initial beliefs


//Plans
+!register <- 	.df_register("seller").

+!sell(Item, StartPrice, IncreaseRate)
	<-	.wait(1000); //waiting group formation
		//Creating Artifact name
		.my_name(Me);
		.concat(Me,act_, Item, ArtName);
		
		//Making Artifact
		joinWorkspace(room, WspId);
		makeArtifact(ArtName, "tools.AuctionRoom", [], ArtId)[wid(WspId)];
		focus(ArtId)[wid(WspId)];
		//Setting parameters of the auction
		set(Item, StartPrice, IncreaseRate, 100)[artifact_id(ArtId),wid(WspId)];
			
		//Setting arguments
		setArgumentValue(enter_auction, auction_room_name, ArtName);
		setArgumentValue(enter_auction, item_name, Item);
		setArgumentValue(enter_auction, item_price, StartPrice);
		setArgumentValue(start_auction, auction_room_name, ArtName);
		setArgumentValue(set_winner, auction_room_name, ArtName);
		setArgumentValue(pay_seller, auction_room_name, ArtName);
		setArgumentValue(dispose_auction_room, auction_room_name, ArtName);
		
		//Sync enter in room
		.wait(1000);
		+rum_enter
		
		.wait(1000);
		+rum_auction
		.

+!sync[scheme(S)]
	<- 	.wait({+rum_enter});
		-rum_enter.
	
+!start_auction[scheme(S)]
	<- 	.wait({+rum_auction});
		-rum_auction;
		.print("Starting auction!");
		?goalArgument(S, enter_auction, "auction_room_name", ArtName);
		lookupArtifact(ArtName, ArtId);
		focus(ArtId);
		startAuction[artifact_id(ArtId)]
		.	
		
+!set_winner[scheme(S)]
	<- 	?goalArgument(S, set_winner, "auction_room_name", ArtName);
		lookupArtifact(ArtName, ArtId);
		//wait result
		.wait({+winner(WinAG)[artifact_id(ArtId)]});
		!set_ag_winner(ArtId).		

+!set_ag_winner(ArtId)
	: winner(WinAG)[artifact_id(ArtId)] & WinAG \== fail
	<- 	.print(WinAG, " won!").
		
+!set_ag_winner(ArtId)
	: 	winner(WinAG)[artifact_id(ArtId)] & WinAG == fail
	<- 	?item(Item)[artifact_id(ArtId)];
		?value(Price)[artifact_id(ArtId)];
		.print("Failure ", Item, " RS ", Price).
		
+!dispose_auction_room[scheme(S)]
	<-	.print("Disposing...");
		?goalArgument(S, dispose_auction_room, "auction_room_name", ArtName);
		lookupArtifact(ArtName, ArtId);
		disposeArtifact(ArtId).
		
		
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$moiseJar/asl/org-obedient.asl") }