package com.iwe.avenger.exception;

public class AvengerNotFoundException extends RuntimeException {
	public AvengerNotFoundException(String msg) {
		super( msg );
	}

	public AvengerNotFoundException() {
		super();
	}

	public AvengerNotFoundException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

	public AvengerNotFoundException(String message, Throwable cause) {
		super(message, cause);
	}

	public AvengerNotFoundException(Throwable cause) {
		super(cause);
	}
	
	
}
