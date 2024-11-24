import 'dart:convert';

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String userType;
  final UserInfo userInfo;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userType,
    required this.userInfo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userType: json['userType'],
      userInfo: UserInfo.fromJson(json['userInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userType': userType,
      'userInfo': userInfo.toJson(),
    };
  }
}

class UserInfo {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String roleId;
  final String? googleId;
  final String provider;
  final Role role;
  final Vendor? vendor;

  UserInfo({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.roleId,
    this.googleId,
    required this.provider,
    required this.role,
    this.vendor,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      isEmailVerified: json['isEmailVerified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      roleId: json['roleId'],
      googleId: json['googleId'],
      provider: json['provider'],
      role: Role.fromJson(json['Role']),
      vendor: json['Vendor'] != null ? Vendor.fromJson(json['Vendor']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'roleId': roleId,
      'googleId': googleId,
      'provider': provider,
      'Role': role.toJson(),
      'Vendor': vendor?.toJson(),
    };
  }
}

class Role {
  final String id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Vendor {
  final String id;
  final String userId;
  final String businessName;
  final String businessType;
  final String taxId;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String phone;
  final String email;
  final String? website;
  final String? logo;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vendor({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.businessType,
    required this.taxId,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
    required this.email,
    this.website,
    this.logo,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      userId: json['userId'],
      businessName: json['businessName'],
      businessType: json['businessType'],
      taxId: json['taxId'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      logo: json['logo'],
      isVerified: json['isVerified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessName': businessName,
      'businessType': businessType,
      'taxId': taxId,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'phone': phone,
      'email': email,
      'website': website,
      'logo': logo,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
