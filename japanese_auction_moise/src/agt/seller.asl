//************************
//****** SELLER **********
//************************

//Initial goals
!register.

//Initial beliefs


//Plans
+!register <- 	joinWorkspace(room, WspId);
				.df_register("seller").

+!sell(Item, StartPrice, IncreaseRate)
	<-	//Waiting buyers registring
		.wait(500);
		
		//Creating Artifact name
		.my_name(Me);
		.concat(Me,act_, Item, ArtName);
		
		//Making Artifact
		makeArtifact(ArtName, "tools.AuctionRoom", [], ArtId);
		focus(ArtId);
		
		//Setting parameters of the auction
		set(Item, StartPrice, IncreaseRate, 100)[artifact_id(ArtId)];
		
		//Sending information to potential buyers
		.df_search("buyer", PB);
		.send(PB, tell, selling(Item, StartPrice, ArtName));
		
		//Starting auction
		.wait(1000);
		startAuction[artifact_id(ArtId)];
		.

+winner(WinAG)[artifact_id(ArtId)] 
	: 	WinAG \== fail
	<- 	.print(WinAG, " won!");
		.wait(1000); //one second to get results
		disposeArtifact(ArtId).
		
+winner(WinAG)[artifact_id(ArtId)] 
	: 	WinAG == fail
	<- 	?item(Item)[artifact_id(ArtId)];
		?value(Price)[artifact_id(ArtId)];
		.print("Failure ", Item, " RS ", Price);
		.wait(1000);  //one second to get results
		disposeArtifact(ArtId).	
		
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }