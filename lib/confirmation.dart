import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:intl/intl.dart';
import 'package:plan_it_on/Methods/getPass.dart';
import 'package:plan_it_on/SuccessBooking.dart';
import 'package:plan_it_on/config/config.dart';
import 'package:plan_it_on/globals.dart';
import 'package:random_string/random_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BuyTicket extends StatefulWidget {
  DocumentSnapshot post;
  BuyTicket(this.post);

  @override
  _BuyTicketState createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  Razorpay _razorpay=Razorpay();
  int _ticketCount=1;
  double _value=1.0;

  @override
  void initState(){
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[                
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:15.0 , left:15.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .12,
                          height: MediaQuery.of(context).size.width * .12,
                          child: IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_left,
                                size: 28.0,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .75,
                          child: Text(
                            widget.post.data['eventName'],
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: AppColors.primary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:20),
                  Align(
                    alignment: Alignment.centerLeft,            
                    child: Padding(
                      padding: const EdgeInsets.only(left:15,bottom:12),
                      child: Text('Price per Pass',style: GoogleFonts.cabin(fontWeight:FontWeight.w800,fontSize:25,color: Color(0xff1E0A3C),)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft, 
                    child: Padding(
                      padding: const EdgeInsets.only(left:15,),
                      child: Text(
                        '₹ ${widget.post.data['isPaid']?widget.post.data['ticketPrice']:'Free'}',
                        style:GoogleFonts.mavenPro(fontWeight:FontWeight.w500,fontSize:22,color: Color(0xff39364f),))
                    ),
                  ),
                  SizedBox(height:10),
                  Divider(thickness:1),
                  SizedBox(height:8),
                  Align(
                    alignment: Alignment.centerLeft,            
                    child: Padding(
                      padding: const EdgeInsets.only(left:15,bottom:12),
                      child: Text('Date and Time',style: GoogleFonts.cabin(fontWeight:FontWeight.w800,fontSize:25,color: Color(0xff1E0A3C),)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft, 
                    child: Padding(
                      padding: const EdgeInsets.only(left:15,),
                      child: Text(
                        '${DateFormat('EEE, d MMMM yyyy').format(widget.post.data['eventDateTime'].toDate())} at ${DateFormat('hh:mm a').format(widget.post.data['eventDateTime'].toDate())}',
                        style:GoogleFonts.mavenPro(fontWeight:FontWeight.w500,fontSize:16,color: Color(0xff39364f),)),
                    ),
                  ),
                  SizedBox(height:10),
                  Divider(thickness:1),
                  SizedBox(height:8),
                  Align(
                    alignment: Alignment.centerLeft,            
                    child: Padding(
                      padding: const EdgeInsets.only(left:15,bottom:12),
                      child: Text('Address',style: GoogleFonts.cabin(fontWeight:FontWeight.w800,fontSize:25,color: Color(0xff1E0A3C),)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft, 
                    child: Padding(
                      padding: const EdgeInsets.only(left:15,),
                      child: Text(
                        '${widget.post.data['isOnline']?'Online Event':'${widget.post.data['eventAddress']}'}',
                        style:GoogleFonts.mavenPro(fontWeight:FontWeight.w500,fontSize:16,color: Color(0xff39364f),)),
                    ),
                  ),
                  SizedBox(height:10),
                  Divider(thickness:1),
                  SizedBox(height:8),
                  widget.post.data['isPaid']?Align(
                    alignment: Alignment.centerLeft,            
                    child: Padding(
                      padding: const EdgeInsets.only(left:15,bottom:12),
                      child: Text('How many Tickets?',style: GoogleFonts.cabin(fontWeight:FontWeight.w800,fontSize:25,color: Color(0xff1E0A3C),)),
                    ),
                  ):Container(),
                  widget.post.data['isPaid']?Center(
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15),
                      child: FluidSlider(
                        sliderColor: AppColors.tertiary,
                        thumbColor: AppColors.primary,
                        valueTextStyle: TextStyle(color:Colors.white),
                        value: _value,
                        showDecimalValue: false,
                        onChanged: (double newValue) {
                          setState(() {
                            _value=newValue;
                            _ticketCount = newValue.toInt();
                          });
                        },
                        min: 1.0,
                        max: 10.0,
                      ),
                    ),):Container(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0,bottom: 10.0),
                    child: Text(
                      widget.post.data['isPaid']?'₹ ${widget.post.data['ticketPrice']*_ticketCount}':'FREE',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal:40.0 , vertical:10.0),
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(color:  AppColors.secondary , borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0))),
                    child: InkWell(
                      onTap:() async{
                        if(widget.post.data['isPaid'])
                          openCheckout(widget.post.data['ticketPrice']*_ticketCount);
                        else
                          await GetPass().bookPass(widget.post, _ticketCount, null).then(
                            (value){
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                                return Success(passCode:value,eventCode:widget.post.data['eventCode'],payment_id: null,isOnline: widget.post.data['isOnline'],);
                              }),ModalRoute.withName("/homepage"));
                            });
                      },
                      child: Center(child: Text('Pay' , style: TextStyle(color: Colors.white ,fontSize: 25.0 , fontWeight:FontWeight.bold)))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
   void openCheckout(double amount) async {

    var options = {
      'key': 'rzp_test_df25oDEIBVWDyE',
      'amount': double.parse(amount.toStringAsFixed(2))*100.toInt(),
      "currency": "INR",
      'name':widget.post.data['eventName'],
      'description': '${DateFormat('EEE, d MMMM yyyy').format(widget.post.data['eventDateTime'].toDate())} at ${DateFormat('hh:mm a').format(widget.post.data['eventDateTime'].toDate())}',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    Fluttertoast.showToast(
      backgroundColor: Colors.green,
      textColor: Colors.white,
      msg: "SUCCESS: " + response.paymentId,);

    await GetPass().bookPass(widget.post, _ticketCount, response).then(
      (value){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
          return Success(passCode:value,eventCode:widget.post.data['eventCode'],payment_id: response.paymentId,isOnline: widget.post.data['isOnline'],);
        }),ModalRoute.withName("/homepage"));
      });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      backgroundColor: Colors.green,
      textColor: Colors.white,
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      backgroundColor: Colors.green,
      textColor: Colors.white,
      msg: "EXTERNAL_WALLET: " + response.walletName,);
  }
}