const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);
// Checks to see if a customer for the e-mail exists
// Example: getCustomer.post().form({email: "darran7777777@gmail.com"})
exports.getCustomer = functions.https.onRequest(function (req, res) {
    return cors(req, res, function () {
        stripe.customers.list({
            email: req.body.email
        }, function (err, customer) {
            if (customer) {
                res.status(200).send(customer);
            }
            else {
                console.log(err);
                reportError(err);
            }
        });
    });
});
// Creates a Payment Method (Credit Card)
// Example: createPaymentMethod.post().form({})
exports.createPaymentMethod = functions.https.onRequest(function (req, res) {
    return cors(req, res, function () {
        var data = JSON.parse(req.body);
        stripe.paymentMethods.create({
            type: 'card',
            card: {
                number: data.number,
                exp_month: data.exp_month,
                exp_year: data.exp_year,
                cvc: data.cvc
            }
        }, function (err, customer) {
            if (customer) {
                res.status(200).send(customer);
            }
            else {
                res.status(err.statusCode).send(err.message);
                reportError(err);
            }
        });
    });
});
// Attach a payment to a customer
// Example: attachPaymentToCustomer.post().form({paymentId: "pm_1GQlt6Gcfq2ACyKQ8dLzesOQ", customerId: "cus_GyjPbiztjArVD9"})
exports.attachPaymentToCustomer = functions.https.onRequest(function (req, res) {
    var data = JSON.parse(req.body);
    stripe.paymentMethods.attach(data.paymentId, {
        customer: data.customerId
    }, function (err, customer) {
        if (customer) {
            res.status(200).send(customer);
        }
        else {
            reportError(err);
        }
    });
});
// Create a Payment Intent. Currently accepts amount and currency
// Example: createPaymentIntent.post().form({amount: 777, currency: "usd"})
exports.createPaymentIntent = functions.https.onRequest(function (req, res) {
    stripe.paymentIntents.create({
        amount: req.body.amount,
        currency: req.body.currency,
        payment_method_types: ['card']
    }, function (err, paymentIntent) {
        if (paymentIntent) {
            console.log("the paymentIntent response: " + paymentIntent);
            res.status(200).send(paymentIntent);
        }
        else {
            reportError(err);
        }
    });
});
// To keep on top of errors, we should raise a verbose error report with Stackdriver rather
// than simply relying on console.error. This will calculate users affected + send you email
// alerts, if you've opted into receiving them.
// [START reporterror]
function reportError(err, context) {
    if (context === void 0) { context = {}; }
    console.log(err);
}
// [END reporterror] 

exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

