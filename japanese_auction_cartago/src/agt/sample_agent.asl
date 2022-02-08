// Agent sample_agent in project japanese_auction_cartago

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true <- 	
					for ( focused(_,_,ArtId) ) {
						enter[artifact_id(ArtId)];
          				startAuction[artifact_id(ArtId)]
      				}.
					
+value(V)[artifact_id(ArtId)]: true <- .print("Valor: ", V, " source = ", ArtId).					
										

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
