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
	<-	.df_register("buyer");
		.df_subscribe("seller").

//Entering in the arena
+selling(Item, Price)[source(A)]
	: 	i_can_buy(Item, Price) & not iwp(Item, A)
	<-	.print("Participating in ", Item);
		+iwp(Item, A);
		.send(A, tell, iwp(Item)). //I wanna participate

//Getting out and not entering anymore in the arena	
+selling(Item, Price)[source(A)]
	: 	not i_can_buy(Item, Price) & iwp(Item, A)
	<-	.print("Geting out of ", Item);
		-iwp(Item, A);
		.send(A, untell, iwp(Item)). //I don't want participate anymore
		
+won(Item, Price)[source(A)]
	: 	iwp(Item, A) & money(Value)
	<- 	-iwp(Item, A);
		-i_want(Item, _);
		-+money(Value - Price);
		.print("I won the item (", Item, "). I paid ", Price, ". Now I have ", Value - Price).
