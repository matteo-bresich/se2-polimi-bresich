for (every car reservation status changed)
	if (reservation status == ON HOLD)
		no action;
	else if (reservation status == ACTIVE)
		no action;
	else if (reservation status == DELETED)
		no action;
	else if (reservation status == EXPIRED)
		calculate(expire_fee);
	else
		get reservation type;
		if (reservation type == NON SHARED)
			calculate non shared cost;
		else 
			calculate shared cost;
	payment process;