# Smarty Park

Blockchain-based micro-parking system. Earn money from your empty parking space.

## The Pitch

Chances are you have a parking space which you don't use for at least 40% of the day. It may be a walk from the local town, it may be in an area where car parks are a premium. Smarty Park aims to distrupt the car parking sector in the same way Über did for taxi services.

Car parks have a cartel of sorts. They can set whatever price they like, charge for periods in blocks (e.g., 2-5hrs parking for £15, _rounded up_ to the nearest hour). Equally, if you loose your parking ticket, or forget to pay, you're likely to be fined an extortionate amount and may even end up with points on your license. With community-sourced car parking, there is no cartel and each Space owner can decide how much they wish to charge on a minutely basis.

Blockchain makes peer-2-peer automated payments trivial, so micro-parking becomes almost like a Cloud service - you pay for the exact amount of time you use. Owners of the parking space can set times during the day when they don't need the space and are happy for others to use it.

Users of the service must abide by the rules and leave the space oil-free and the surrounding grass undamaged or they are likely to receive a negative review from the space owner. Negative reviews can harm the user's ability to use spaces, with premium spaces having higher barriers of entry, requiring no bad reviews. This encourages the space to be respected.

## Workflow

Space owners (or "Landlords") register a space on the Blockchain alongside a series of time periods the space can be used and any associated rules. A QR code is generated which the Landlord must display, advertising the space to passers by. Landlords can also choose to purchase an official Smarty Park sign which can be either mounted on a wall, or steaked into the ground.

When a User (or "Tenant") needs to park, their app can search for near by spaces which are available (i.e., their reviews are high enough and it is currently within one of the time periods available for hire). The tenant requests the space on the app when they are either nearby _or_ as they park by scanning the QR Code.

The QR Code takes them to a dApp which connects to their wallet. It will send ~£10 **(TBC)** in an escrow account and record the time the rental started in the Blockchain. When the User returns and moves the car, they can check-out from either the app or the QR Code - recording the exit time on the blockchain. They are then refunded their £10 deposit minus the exact amount via the algorithm `minutes parked * price per minute`.

If someone parks in the space out of hours, or breaks any of the rules (e.g., out stay the maximum stay), at the Landlord's discretion, a negative review can be applied against the car's registration number. This will mean _any_ wallets wishing to park this car will have a negative review on the account for a period of 1 year **(TBC)**. Even when selling the car, the reviews remain affixed to the car.

## Automated IoT Security

Landlords wishing to purchase a Smarty Park AMPR camera can do so for automated security, detecting incorrect registration numbers, lies about check-out times etc. allocating auto-assigned negative reviews and issuing fines which are auto-applied to the next rental the User attempts.
