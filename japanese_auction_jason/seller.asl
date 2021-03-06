//************************
//****** SELLER **********
//************************

//Initial goals
!register.

//Initial beliefs


//Plans
+!register <- .df_register("seller").

+!sell(Item, StartPrice, IncreaseRate)
	<-	!search_buyers(Item, StartPrice);
		.wait(1000); //receiving beliefs of  iwp
		!raise_price(Item, StartPrice, IncreaseRate).
	
+!search_buyers(Item, StartPrice)
	<-	.wait(1000);
		.df_search("buyer", PB);
		.send(PB, tell, selling(Item, StartPrice)).
		
+!raise_price(Item, Price, IncreaseRate)
	: 	.findall(A, iwp(Item)[source(A)], B) & .length(B,X) & X > 1
	<-	//.print("Raising price from ", Price, " to ", Price * IncreaseRate);
		.send(B, tell, selling(Item, Price * IncreaseRate));
		.wait(100); //waiting for untell
		!raise_price(Item, Price * IncreaseRate, IncreaseRate).
		
+!raise_price(Item, Price, IncreaseRate)
	: 	.findall(A, iwp(Item)[source(A)], B)  & .length(B,1)
	<-	.print(B, " won!");
		.send(B, tell, won(Item, Price)).		
	
+!raise_price(Item, Price, IncreaseRate)
	<-	.print("Failure ", Item, " RS ", Price).	
