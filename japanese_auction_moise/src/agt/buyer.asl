//************************
//****** BUYER ***********
//************************

//Test
i_can_buy(Item, Price) :- 	i_want(Item, MaxValue) & money(T) & 
							(T >= Price) & (MaxValue >= Price).

//Initial goals


//Plans
+!enter_auction[scheme(S)]
	<- 	?goalArgument(S, enter_auction, "auction_room_name", ArtName);
		?goalArgument(S, enter_auction, "item_name", Item);
		?goalArgument(S, enter_auction, "item_price", Price);	
		if(i_can_buy(Item, Price))
		{
			joinWorkspace(room, WspId);
			lookupArtifact(ArtName, ArtId)[wid(WspId)];
			focus(ArtId)[wid(WspId)];
			enter[artifact_id(ArtId)];
			.print("Entering the auction")
		}
		else
		{
			.print("NOT entering the auction")
		}
		.
	
//Getting out and not entering anymore in the arena	
+value(Price)[artifact_id(ArtId)] 
	: 	item(Item)[artifact_id(ArtId)] & not i_can_buy(Item, Price)  
	<-	.print("Geting out of ", Item, " from ", ArtId);
		quit[artifact_id(ArtId)];
		stopFocus(ArtId); //Get out of the artifact.
		.

+!pay_seller[scheme(S)]
	<- 	?goalArgument(S, pay_seller, "auction_room_name", ArtName);
		lookupArtifact(ArtName, ArtId);
		!payment(ArtId)
		.	

+!payment(ArtId)
	: 	winner(WinAg)[artifact_id(ArtId)] &
		.my_name(Me) & Me == WinAg
		
	<- 	?item(Item)[artifact_id(ArtId)];
		?value(Price)[artifact_id(ArtId)];
		?money(Value);
		-i_want(Item, _);
		+won(Item, Price);
		-+money(Value - Price);
		stopFocus(ArtId);  //Get out of the artifact.
		.print("I won the item (", Item, ") from ", ArtId, ". I paid ", Price, ". Now I have ", Value - Price);
		.	

+!payment(ArtId).
			
		
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$moiseJar/asl/org-obedient.asl") }	