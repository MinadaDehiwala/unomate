import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class BusinessSignupScreen extends StatefulWidget {
  @override
  _BusinessSignupScreenState createState() => _BusinessSignupScreenState();
}

class _BusinessSignupScreenState extends State<BusinessSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _otherNames = '';
  String _businessName = '';
  DateTime _dob = DateTime.now();
  String _nic = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isNicFrontUploaded = false;
  bool _isNicBackUploaded = false;
  bool _isSelfieUploaded = false;

  File? _nicFrontFile;
  File? _nicBackFile;
  File? _selfieFile;

  Future<void> _pickImage(ImageSource source, String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        if (type == 'nic_front') {
          _isNicFrontUploaded = true;
          _nicFrontFile = File(pickedFile.path);
        }
        if (type == 'nic_back') {
          _isNicBackUploaded = true;
          _nicBackFile = File(pickedFile.path);
        }
        if (type == 'selfie') {
          _isSelfieUploaded = true;
          _selfieFile = File(pickedFile.path);
        }
      }
    });
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.black54,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white54),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.purpleAccent),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Future<String?> _uploadImageToFirebase(File imageFile, String path) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);

        String? nicFrontUrl;
        String? nicBackUrl;
        String? selfieUrl;

        if (_nicFrontFile != null) {
          nicFrontUrl = await _uploadImageToFirebase(_nicFrontFile!, 'nic_front/${userCredential.user!.uid}.jpg');
        }

        if (_nicBackFile != null) {
          nicBackUrl = await _uploadImageToFirebase(_nicBackFile!, 'nic_back/${userCredential.user!.uid}.jpg');
        }

        if (_selfieFile != null) {
          selfieUrl = await _uploadImageToFirebase(_selfieFile!, 'selfie/${userCredential.user!.uid}.jpg');
        }

        await FirebaseFirestore.instance
            .collection('businesses')
            .doc(userCredential.user!.uid)
            .set({
          'first_name': _firstName,
          'last_name': _lastName,
          'other_names': _otherNames,
          'business_name': _businessName,
          'date_of_birth': _dob.toIso8601String(),
          'nic': _nic,
          'email': _email,
          'nic_front_url': nicFrontUrl,
          'nic_back_url': nicBackUrl,
          'selfie_url': selfieUrl,
        });

        // Show success message or navigate to another screen
      } on FirebaseAuthException catch (e) {
        // Handle error
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/business_signup.png',
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
                    const SizedBox(height: 320), // Adjust space at the top to move everything down
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: _buildInputDecoration('First Name'),
                            style: const TextStyle(color: Colors.white),
                            onSaved: (value) {
                              _firstName = value!;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: _buildInputDecoration('Last Name'),
                            style: const TextStyle(color: Colors.white),
                            onSaved: (value) {
                              _lastName = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('Other Names'),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (value) {
                        _otherNames = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('Business Name'),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (value) {
                        _businessName = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('Date of Birth'),
                      style: const TextStyle(color: Colors.white),
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
                      controller: TextEditingController(
                        text: "${_dob.toLocal()}".split(' ')[0],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('NIC'),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (value) {
                        _nic = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('Email'),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: _buildInputDecoration('Password'),
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: _buildInputDecoration('Confirm Password'),
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            onSaved: (value) {
                              _confirmPassword = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _pickImage(ImageSource.camera, 'nic_front'),
                              child: const Text('NIC Front'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.white,
                              ),
                            ),
                            if (_isNicFrontUploaded)
                              const Icon(Icons.check_circle, color: Colors.green),
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _pickImage(ImageSource.camera, 'nic_back'),
                              child: const Text('NIC Back'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.white,
                              ),
                            ),
                            if (_isNicBackUploaded)
                              const Icon(Icons.check_circle, color: Colors.green),
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _pickImage(ImageSource.camera, 'selfie'),
                              child: const Text('Selfie'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.white,
                              ),
                            ),
                            if (_isSelfieUploaded)
                              const Icon(Icons.check_circle, color: Colors.green),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
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
