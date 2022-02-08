//************************
//****** BUYER ***********
//************************

//Test
i_can_buy(Item, Price) :- 	i_want(Item, MaxValue) & money(T) & 
							(T >= Price) & (MaxValue >= Price).

//Initial goals
!register.

//Initial beliefs
//money(Value)
//The money I have
//money(1000).
//i_want(Item, Value)
//I want Item paying no more than Value
//i_want(tst, 250).

//Plans
+!register 
	<-	joinWorkspace(room, WspId);
		.df_register("buyer");
		.df_subscribe("seller").

//Entering in the arena
+selling(Item, Price, ArtName)[source(A)]
	: 	i_can_buy(Item, Price)
	<-	.print("Participating in ", Item);
		lookupArtifact(ArtName, ArtId);
		focus(ArtId);
		enter[artifact_id(ArtId)];
		. 

//Getting out and not entering anymore in the arena	
 +value(Price)[artifact_id(ArtId)] 
	: 	item(Item)[artifact_id(ArtId)] & not i_can_buy(Item, Price)  
	<-	.print("Geting out of ", Item, " from ", ArtId);
		quit[artifact_id(ArtId)];
		stopFocus(ArtId); //Get out of the artifact.
		.
		
+winner(WinAg)[artifact_id(ArtId)]
	:	.my_name(Me) & Me == WinAg
	<- 	?item(Item)[artifact_id(ArtId)];
		?value(Price)[artifact_id(ArtId)];
		?money(Value);
		-i_want(Item, _);
		+won(Item, Price);
		-+money(Value - Price);
		stopFocus(ArtId);  //Get out of the artifact.
		.print("I won the item (", Item, ") from ", ArtId, ". I paid ", Price, ". Now I have ", Value - Price).	
		
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }		