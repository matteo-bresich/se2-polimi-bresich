open util/boolean

// Model definition

sig Str{} //String

sig Flo{} //Float

sig Date {}

sig PaymentMethod {}

abstract sig RegisteredUser {
	ID: one Int,
	password: one Str,
	name: one Str,
	surname: one Str,
	email:one Str,
	address: one Str,
	cellphone: one Str,
	savedPaymentMethod: one PaymentMethod,
	activeReservation: lone Reservation
}
{ID >0}

sig Driver extends RegisteredUser{}

sig Passenger extends RegisteredUser{}

sig HandyMandOperator extends RegisteredUser{}

abstract sig Reservation {
	reservationId: one Int,
	car: one Car
}
{reservationId > 0}

sig CarReservation extends Reservation {
	isShared: one Bool,
	numberOfSeatsReserved: one Int,
	seatsReservation: set SeatReservation,
}
{ numberOfSeatsReserved > 0}

sig SeatReservation extends Reservation {
	numberOfSeatsReserved: one Int
}
 { numberOfSeatsReserved > 0}

sig Car {
	carPlate: one Str,
	seats: one Int
}

sig Location {}


// Model constraints
fact noEmptyRegisteredUser {
	all u: RegisteredUser |
		(#u.ID = 1) and (#u . password=1)  and (#u.name = 1) and(#u.surname = 1)
		and (#u.email = 1) and (#u.address = 1) and (#u.cellphone = 1) and (#u.savedPaymentMethod >= 1)
}


fact uniqueUserID {
	no disj u1, u2: RegisteredUser | (u1.ID = u2.ID)
}

fact uniqueRegisteredUser {
	no disj u1, u2: RegisteredUser | (u1.email = u2.email)
}

fact uniqueUserReservation {
	no disj u1, u2: RegisteredUser | (u1.activeReservation = u2.activeReservation)
}

fact uniqueReservation {
	no disj r1, r2: Reservation | (r1.reservationId = r2.reservationId)
}

fact uniqueCar {
	no disj c1, c2: Car | (c1.carPlate = c2.carPlate)
}

fact noSameCarInCarReservation {
	no disj r1, r2: CarReservation | r1.car = r2.car
}

fact carReservationMustHaveAuthor {
	no r:CarReservation | all d: Driver | r not in d.activeReservation
}

fact seatReservationMustHaveAuthor {
	no r:SeatReservation | all p: Passenger | r not in p.activeReservation
}

fact seatReservationMustHaveCarReservation {
	no r:SeatReservation | all c: CarReservation | r not in c.seatsReservation
}

fact seatReservationMustHaveTheSameFatherReservationCar {
	all rs:SeatReservation | all rc: CarReservation | (rs in rc.seatsReservation) => (rs.car = rc.car)
}

//check noPassengersOnNonSharedReservation
assert noPassengersOnNonSharedReservation {
	all r:CarReservation | (r.isShared=False) => (#seatsReservation = 0)
}

//Predicates
pred show() {
	#HandyMandOperator = 1
	#Driver = 2
	#Passenger = 2
	#CarReservation = 2
	#car >=2
	
}
run show for 10
