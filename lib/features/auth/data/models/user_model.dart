class UserModel {
  // ============ اطلاعات پایه ============
  final int id;
  final String employeeCode;
  final String firstName;
  final String lastName;
  final String fullName;
  final String? fatherName;
  final String? nationalId;
  
  // ============ اطلاعات شخصی ============
  final String? gender;
  final String? genderDisplay;
  final String? marriageStatus;
  final String? marriageStatusDisplay;
  final String? birthDate;
  final String? birthDateJalali;
  final int? age;
  
  // ============ اطلاعات تماس ============
  final String? mobile;
  final String? phone;
  final String? emergencyPhone;
  final String? address;
  
  // ============ اطلاعات شغلی ============
  final String? jobRole;
  final String? jobRoleDisplay;
  final int? roleLevel;
  final String? roleLevelDisplay;
  final String? educationLevel;
  final String? educationLevelDisplay;
  final String? employmentType;
  final String? employmentTypeDisplay;
  
  // ============ اطلاعات دپارتمان ============
  final int? department;
  final DepartmentDetail? departmentDetail;
  
  // ============ اطلاعات شیفت کاری ============
  final int? workShift;
  final WorkShiftDetail? workShiftDetail;
  
  // ============ اطلاعات سرپرستی ============
  final int? supervisor;
  final String? supervisorDetail;
  
  // ============ اطلاعات چرخش ============
  final String? rotationGroup;
  final String? rotationGroupDisplay;
  final String? rotationStartDate;
  final String? rotationPattern;
  final int? morningShift;
  final int? nightShift;
  
  // ============ اطلاعات مالی ============
  final String? baseSalary;
  final String? hourlyRate;
  final String? insuranceNumber;
  final String? bankAccountNumber;
  final String? bankCardNumber;
  final String? bankName;
  
  // ============ تاریخ‌ها ============
  final String? employmentDate;
  final String? employmentDateJalali;
  final String? resignationDate;
  
  // ============ تصویر ============
  final String? profileImage;
  
  // ============ وضعیت‌ها ============
  final bool isActive;
  final bool isStaff;
  final bool isSuperuser;
  final bool isSyncedWithDevice;
  final String? deviceUserId;
  
  // ============ زمان‌ها ============
  final String? createdAt;
  final String? updatedAt;
  
  // ============ دسترسی‌ها ============
  final String? hasManagementRole;
  final String? canApproveRequests;
  
  UserModel({
    required this.id,
    required this.employeeCode,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.fatherName,
    this.nationalId,
    this.gender,
    this.genderDisplay,
    this.marriageStatus,
    this.marriageStatusDisplay,
    this.birthDate,
    this.birthDateJalali,
    this.age,
    this.mobile,
    this.phone,
    this.emergencyPhone,
    this.address,
    this.jobRole,
    this.jobRoleDisplay,
    this.roleLevel,
    this.roleLevelDisplay,
    this.educationLevel,
    this.educationLevelDisplay,
    this.employmentType,
    this.employmentTypeDisplay,
    this.department,
    this.departmentDetail,
    this.workShift,
    this.workShiftDetail,
    this.supervisor,
    this.supervisorDetail,
    this.rotationGroup,
    this.rotationGroupDisplay,
    this.rotationStartDate,
    this.rotationPattern,
    this.morningShift,
    this.nightShift,
    this.baseSalary,
    this.hourlyRate,
    this.insuranceNumber,
    this.bankAccountNumber,
    this.bankCardNumber,
    this.bankName,
    this.employmentDate,
    this.employmentDateJalali,
    this.resignationDate,
    this.profileImage,
    this.isActive = true,
    this.isStaff = false,
    this.isSuperuser = false,
    this.isSyncedWithDevice = false,
    this.deviceUserId,
    this.createdAt,
    this.updatedAt,
    this.hasManagementRole,
    this.canApproveRequests,
  });
  
  // ============ Getterهای کمکی ============
  
  String get displayName => fullName.isNotEmpty ? fullName : '$firstName $lastName';
  
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last';
  }
  
  String get genderText {
    if (gender == 'M') return 'مرد';
    if (gender == 'F') return 'زن';
    return 'نامشخص';
  }
  
  String get marriageStatusText {
    if (marriageStatus == 'S') return 'مجرد';
    if (marriageStatus == 'M') return 'متاهل';
    return 'نامشخص';
  }
  
  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;
  
  // ============ Factory ============
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // اطلاعات پایه
      id: json['id'] ?? 0,
      employeeCode: json['employee_code'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fullName: json['full_name'] ?? '',
      fatherName: json['father_name'],
      nationalId: json['national_id'],
      
      // اطلاعات شخصی
      gender: json['gender'],
      genderDisplay: json['gender_display'],
      marriageStatus: json['marriage_status'],
      marriageStatusDisplay: json['marriage_status_display'],
      birthDate: json['birth_date'],
      birthDateJalali: json['birth_date_jalali'],
      age: json['age'],
      
      // اطلاعات تماس
      mobile: json['mobile'],
      phone: json['phone'],
      emergencyPhone: json['emergency_phone'],
      address: json['address'],
      
      // اطلاعات شغلی
      jobRole: json['job_role'],
      jobRoleDisplay: json['job_role_display'],
      roleLevel: json['role_level'],
      roleLevelDisplay: json['role_level_display'],
      educationLevel: json['education_level'],
      educationLevelDisplay: json['education_level_display'],
      employmentType: json['employment_type'],
      employmentTypeDisplay: json['employment_type_display'],
      
      // اطلاعات دپارتمان
      department: json['department'],
      departmentDetail: json['department_detail'] != null
          ? DepartmentDetail.fromJson(json['department_detail'])
          : null,
      
      // اطلاعات شیفت کاری
      workShift: json['work_shift'],
      workShiftDetail: json['work_shift_detail'] != null
          ? WorkShiftDetail.fromJson(json['work_shift_detail'])
          : null,
      
      // اطلاعات سرپرستی
      supervisor: json['supervisor'],
      supervisorDetail: json['supervisor_detail'],
      
      // اطلاعات چرخش
      rotationGroup: json['rotation_group'],
      rotationGroupDisplay: json['rotation_group_display'],
      rotationStartDate: json['rotation_start_date'],
      rotationPattern: json['rotation_pattern'],
      morningShift: json['morning_shift'],
      nightShift: json['night_shift'],
      
      // اطلاعات مالی
      baseSalary: json['base_salary']?.toString(),
      hourlyRate: json['hourly_rate']?.toString(),
      insuranceNumber: json['insurance_number'],
      bankAccountNumber: json['bank_account_number'],
      bankCardNumber: json['bank_card_number'],
      bankName: json['bank_name'],
      
      // تاریخ‌ها
      employmentDate: json['employment_date'],
      employmentDateJalali: json['employment_date_jalali'],
      resignationDate: json['resignation_date'],
      
      // تصویر
      profileImage: json['profile_image'],
      
      // وضعیت‌ها
      isActive: json['is_active'] ?? true,
      isStaff: json['is_staff'] ?? false,
      isSuperuser: json['is_superuser'] ?? false,
      isSyncedWithDevice: json['is_synced_with_device'] ?? false,
      deviceUserId: json['device_user_id'],
      
      // زمان‌ها
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      
      // دسترسی‌ها
      hasManagementRole: json['has_management_role']?.toString(),
      canApproveRequests: json['can_approve_requests']?.toString(),
    );
  }
  
  // ============ ToJson ============
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_code': employeeCode,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'father_name': fatherName,
      'national_id': nationalId,
      'gender': gender,
      'gender_display': genderDisplay,
      'marriage_status': marriageStatus,
      'marriage_status_display': marriageStatusDisplay,
      'birth_date': birthDate,
      'birth_date_jalali': birthDateJalali,
      'age': age,
      'mobile': mobile,
      'phone': phone,
      'emergency_phone': emergencyPhone,
      'address': address,
      'job_role': jobRole,
      'job_role_display': jobRoleDisplay,
      'role_level': roleLevel,
      'role_level_display': roleLevelDisplay,
      'education_level': educationLevel,
      'education_level_display': educationLevelDisplay,
      'employment_type': employmentType,
      'employment_type_display': employmentTypeDisplay,
      'department': department,
      'department_detail': departmentDetail?.toJson(),
      'work_shift': workShift,
      'work_shift_detail': workShiftDetail?.toJson(),
      'supervisor': supervisor,
      'supervisor_detail': supervisorDetail,
      'rotation_group': rotationGroup,
      'rotation_group_display': rotationGroupDisplay,
      'rotation_start_date': rotationStartDate,
      'rotation_pattern': rotationPattern,
      'morning_shift': morningShift,
      'night_shift': nightShift,
      'base_salary': baseSalary,
      'hourly_rate': hourlyRate,
      'insurance_number': insuranceNumber,
      'bank_account_number': bankAccountNumber,
      'bank_card_number': bankCardNumber,
      'bank_name': bankName,
      'employment_date': employmentDate,
      'employment_date_jalali': employmentDateJalali,
      'resignation_date': resignationDate,
      'profile_image': profileImage,
      'is_active': isActive,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
      'is_synced_with_device': isSyncedWithDevice,
      'device_user_id': deviceUserId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'has_management_role': hasManagementRole,
      'can_approve_requests': canApproveRequests,
    };
  }
}

// ============ مدل دپارتمان ============
class DepartmentDetail {
  final int id;
  final String name;
  final String code;
  final String? departmentType;
  
  DepartmentDetail({
    required this.id,
    required this.name,
    required this.code,
    this.departmentType,
  });
  
  factory DepartmentDetail.fromJson(Map<String, dynamic> json) {
    return DepartmentDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      departmentType: json['department_type'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'department_type': departmentType,
    };
  }
}

// ============ مدل شیفت کاری ============
class WorkShiftDetail {
  final int id;
  final String name;
  final String code;
  final String? startTime;
  final String? endTime;
  final String? shiftCategory;
  
  WorkShiftDetail({
    required this.id,
    required this.name,
    required this.code,
    this.startTime,
    this.endTime,
    this.shiftCategory,
  });
  
  factory WorkShiftDetail.fromJson(Map<String, dynamic> json) {
    return WorkShiftDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      startTime: json['start_time'],
      endTime: json['end_time'],
      shiftCategory: json['shift_category'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'start_time': startTime,
      'end_time': endTime,
      'shift_category': shiftCategory,
    };
  }
}