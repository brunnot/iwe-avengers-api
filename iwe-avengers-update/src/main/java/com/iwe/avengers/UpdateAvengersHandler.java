package com.iwe.avengers;

import java.util.Optional;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.iwe.avenger.dao.AvengerDAO;
import com.iwe.avenger.dynamodb.entity.Avenger;
import com.iwe.avenger.exception.AvengerNotFoundException;
import com.iwe.avenger.lambda.response.HandlerResponse;

public class UpdateAvengersHandler implements RequestHandler<Avenger, HandlerResponse> {

	private AvengerDAO dao = new AvengerDAO();
	
	@Override
	public HandlerResponse handleRequest(final Avenger newAvenger, final Context context) {

		context.getLogger().log("[#] - Update Avenger by id: " + newAvenger.getId() );
		
		final Optional<Avenger> avengerRetrieved = dao.search( newAvenger.getId() );
		if( avengerRetrieved.isPresent() ) {
			
			context.getLogger().log("[#] - Avenger found " + avengerRetrieved.get().getName() );
			
			final Avenger avenger = dao.save( newAvenger );
			
			return HandlerResponse.builder().setObjectBody(avenger).build();
		} 
		
		throw new AvengerNotFoundException("[NotFound] - Avenger id: " + newAvenger.getId() );
		
		

	}
}
