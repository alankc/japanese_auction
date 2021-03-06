// CArtAgO artifact code for project japanese_auction_cartago

package tools;

import java.util.ArrayList;
import java.util.List;

import cartago.*;
import jason.asSyntax.Atom;

public class AuctionRoom extends Artifact {
	
	private double increaseRate;
	private long delay;

	private List<String> buyers;
	private List<String> remainingBuyers;
	
	void init() {
		//defineObsProperty("item", "");
		//defineObsProperty("value", 0);
		//defineObsProperty("winner", "");
		
		//this.increaseRate = increaseRate;
		//this.delay = delay;
		
		this.buyers = new ArrayList<String>();
		this.remainingBuyers = new ArrayList<String>();
		
	}
	
	@OPERATION
	void set(String itemName, double value, double increaseRate, long delay) {
		defineObsProperty("item", new Atom(itemName));
		//defineObsProperty("item", itemName);
		defineObsProperty("value", value);
		
		this.increaseRate = increaseRate;
		this.delay = delay;
	}

	@OPERATION
	void enter() {
		
		String name = getCurrentOpAgentId().getAgentName();
		
		//Can enter only one time
		if (buyers.contains(name)) {
			failed("You have entered already!");
		} else {
			buyers.add(name);
			remainingBuyers.add(name);
		}
	}
	
	@OPERATION
	void quit() {
		//If you are the last, you can't get out
		//if (remainingBuyers.size() == 1)
			//failed("You are the last, you can't get out!");	
		//If your name is not in the list, you can't get out 
		//else 
			if (!remainingBuyers.remove(getCurrentOpAgentId().getAgentName()))
				failed("Your name is not in the list!");
	}
	
	@OPERATION
	void startAuction() {
		if (remainingBuyers.isEmpty()) {
			defineObsProperty("winner", new Atom("fail"));
		} else {
			execInternalOp("raise_price");
		}
	}
	
	@INTERNAL_OPERATION
	void raise_price() {
		
		getObsProperty("value").updateValue(getObsProperty("value").getValue());
		getObsProperty("item").updateValue(getObsProperty("item").getValue());
		
		ObsProperty price = getObsProperty("value");
		
		while(remainingBuyers.size() > 1)
		{
			double newValue = (double)price.getValue();
			newValue = newValue * increaseRate;
			price.updateValue(newValue);
			//System.out.println("Raising price from " + price.getValue() + " to " + newValue);
			this.await_time(delay);
		}
		
		signal("end_auction");
		
		if (remainingBuyers.isEmpty()) {
			defineObsProperty("winner", new Atom("fail"));
		} else {
			defineObsProperty("winner", new Atom(remainingBuyers.get(0)));
		}
	}
}

