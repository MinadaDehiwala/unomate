import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentSignupScreen extends StatefulWidget {
  @override
  _StudentSignupScreenState createState() => _StudentSignupScreenState();
}

class _StudentSignupScreenState extends State<StudentSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  DateTime _dob = DateTime.now();
  String _nic = '';
  String _selectedGender = 'Male';
  late String _selectedUniversity;
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  List<String> _universities = [
    'University of Colombo',
    'University of Peradeniya',
    'University of Sri Jayewardenepura',
    'University of Moratuwa',
    'University of Kelaniya',
    'University of Ruhuna',
    'University of Jaffna',
    'Rajarata University of Sri Lanka',
    'Sabaragamuwa University of Sri Lanka',
    'Uva Wellassa University',
    'South Eastern University of Sri Lanka',
    'Wayamba University of Sri Lanka',
    'Eastern University of Sri Lanka',
    'University of the Visual and Performing Arts',
    'Buddhist and Pali University',
    'General Sir John Kotelawala Defence University',
    'Gampaha Wickramarachchi University',
    'University of Vavuniya'
  ];

  @override
  void initState() {
    super.initState();
    _selectedUniversity = _universities[0]; // Initialize with the first university
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);

        await FirebaseFirestore.instance
            .collection('students')
            .doc(userCredential.user!.uid)
            .set({
          'first_name': _firstName,
          'last_name': _lastName,
          'date_of_birth': _dob,
          'nic': _nic,
          'gender': _selectedGender,
          'university': _selectedUniversity,
          'email': _email,
        });

        // Navigate to the next screen or show a success message
      } on FirebaseAuthException catch (e) {
        // Handle error
        print(e);
      }
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.black54,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.purpleAccent),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/student_login.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 370), // Adjust space at the top to move everything down
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: _buildInputDecoration('First Name'),
                            onSaved: (value) {
                              _firstName = value!;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: _buildInputDecoration('Last Name'),
                            onSaved: (value) {
                              _lastName = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('Date of Birth'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _dob,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null && pickedDate != _dob)
                          setState(() {
                            _dob = pickedDate;
                          });
                      },
                      readOnly: true,
                      style: TextStyle(color: Colors.white), // Make the date text white
                      controller: TextEditingController(
                        text: "${_dob.toLocal()}".split(' ')[0],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('NIC'),
                      onSaved: (value) {
                        _nic = value!;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: _buildInputDecoration('Gender'),
                      dropdownColor: Colors.black54,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedGender = newValue!;
                        });
                      },
                      items: <String>['Male', 'Female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedUniversity,
                      decoration: _buildInputDecoration('University'),
                      dropdownColor: Colors.black54,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUniversity = newValue!;
                        });
                      },
                      items: _universities
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('Email'),
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: _buildInputDecoration('Password'),
                            obscureText: true,
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: _buildInputDecoration('Confirm Password'),
                            obscureText: true,
                            onSaved: (value) {
                              _confirmPassword = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Color(0xFF9C3FE4), Color(0xFFC65647)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Sign Up', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
