import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../models/donation_model.dart';
import '../models/meeting_model.dart';
import '../models/mou_model.dart';
import '../models/certificate_model.dart';
import '../models/document_model.dart';
import '../models/joining_letter_model.dart';
import '../core/enums/user_role.dart';
import '../core/enums/status.dart';

class AppDataProvider extends ChangeNotifier {
  // ─── Users ────────────────────────────────────────────────────────────────
  late List<UserModel> _users;
  // ─── Tasks ────────────────────────────────────────────────────────────────
  late List<TaskModel> _tasks;
  // ─── Donations ────────────────────────────────────────────────────────────
  late List<DonationModel> _donations;
  // ─── Meetings ─────────────────────────────────────────────────────────────
  late List<MeetingModel> _meetings;
  // ─── MOU ──────────────────────────────────────────────────────────────────
  late List<MouModel> _mouRequests;
  // ─── Certificates ─────────────────────────────────────────────────────────
  late List<CertificateModel> _certificates;
  // ─── Documents ────────────────────────────────────────────────────────────
  late List<DocumentModel> _documents;
  // ─── Joining Letters ──────────────────────────────────────────────────────
  late List<JoiningLetterModel> _joiningLetters;

  AppDataProvider() {
    _initMockData();
  }

  // ─── Getters ──────────────────────────────────────────────────────────────
  List<UserModel> get users => List.unmodifiable(_users);
  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  List<DonationModel> get donations => List.unmodifiable(_donations);
  List<MeetingModel> get meetings => List.unmodifiable(_meetings);
  List<MouModel> get mouRequests => List.unmodifiable(_mouRequests);
  List<CertificateModel> get certificates => List.unmodifiable(_certificates);
  List<DocumentModel> get documents => List.unmodifiable(_documents);
  List<JoiningLetterModel> get joiningLetters => List.unmodifiable(_joiningLetters);

  // ─── Filtered getters ─────────────────────────────────────────────────────
  List<UserModel> get members =>
      _users.where((u) => u.role == UserRole.member).toList();

  List<UserModel> get volunteers =>
      _users.where((u) => u.role == UserRole.volunteer).toList();

  List<UserModel> get admins =>
      _users.where((u) => u.role == UserRole.admin || u.role == UserRole.superAdmin).toList();

  List<MeetingModel> get upcomingMeetings =>
      _meetings.where((m) => m.isUpcoming).toList();

  List<MeetingModel> get pastMeetings =>
      _meetings.where((m) => !m.isUpcoming).toList();

  double get totalDonations =>
      _donations.fold(0, (sum, d) => sum + d.amount);

  List<TaskModel> tasksForUser(String userId) =>
      _tasks.where((t) => t.assignedToId == userId).toList();

  List<TaskModel> get pendingTasks =>
      _tasks.where((t) => t.status == TaskStatus.pending).toList();

  List<TaskModel> get submittedTasks =>
      _tasks.where((t) => t.status == TaskStatus.submitted).toList();

  // ─── User operations ──────────────────────────────────────────────────────
  void addUser(UserModel user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(UserModel updated) {
    final idx = _users.indexWhere((u) => u.id == updated.id);
    if (idx != -1) {
      _users[idx] = updated;
      notifyListeners();
    }
  }

  void removeUser(String id) {
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }

  UserModel? getUserById(String id) {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  // ─── Task operations ──────────────────────────────────────────────────────
  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(TaskModel updated) {
    final idx = _tasks.indexWhere((t) => t.id == updated.id);
    if (idx != -1) {
      _tasks[idx] = updated;
      notifyListeners();
    }
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ─── Donation operations ──────────────────────────────────────────────────
  void addDonation(DonationModel donation) {
    _donations.add(donation);
    notifyListeners();
  }

  void updateDonation(DonationModel updated) {
    final idx = _donations.indexWhere((d) => d.id == updated.id);
    if (idx != -1) {
      _donations[idx] = updated;
      notifyListeners();
    }
  }

  // ─── Meeting operations ───────────────────────────────────────────────────
  void addMeeting(MeetingModel meeting) {
    _meetings.add(meeting);
    notifyListeners();
  }

  void updateMeeting(MeetingModel updated) {
    final idx = _meetings.indexWhere((m) => m.id == updated.id);
    if (idx != -1) {
      _meetings[idx] = updated;
      notifyListeners();
    }
  }

  // ─── MOU operations ───────────────────────────────────────────────────────
  void addMouRequest(MouModel mou) {
    _mouRequests.add(mou);
    notifyListeners();
  }

  void updateMouRequest(MouModel updated) {
    final idx = _mouRequests.indexWhere((m) => m.id == updated.id);
    if (idx != -1) {
      _mouRequests[idx] = updated;
      notifyListeners();
    }
  }

  // ─── Certificate operations ───────────────────────────────────────────────
  void addCertificate(CertificateModel cert) {
    _certificates.add(cert);
    notifyListeners();
  }

  void updateCertificate(CertificateModel updated) {
    final idx = _certificates.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      _certificates[idx] = updated;
      notifyListeners();
    }
  }

  // ─── Document operations ──────────────────────────────────────────────────
  void addDocument(DocumentModel doc) {
    _documents.add(doc);
    notifyListeners();
  }

  void updateDocument(DocumentModel updated) {
    final idx = _documents.indexWhere((d) => d.id == updated.id);
    if (idx != -1) {
      _documents[idx] = updated;
      notifyListeners();
    }
  }

  // ─── Joining Letter operations ────────────────────────────────────────────
  void addJoiningLetter(JoiningLetterModel letter) {
    _joiningLetters.add(letter);
    notifyListeners();
  }

  void updateJoiningLetter(JoiningLetterModel updated) {
    final idx = _joiningLetters.indexWhere((l) => l.id == updated.id);
    if (idx != -1) {
      _joiningLetters[idx] = updated;
      notifyListeners();
    }
  }

  // ─── Mock Data Initialisation ─────────────────────────────────────────────
  void _initMockData() {
    _initUsers();
    _initTasks();
    _initDonations();
    _initMeetings();
    _initMouRequests();
    _initCertificates();
    _initDocuments();
    _initJoiningLetters();
  }

  void _initUsers() {
    _users = [
      // Super Admin
      UserModel(
        id: 'u001',
        name: 'Rajesh Kumar',
        email: 'superadmin@jayshreefoundation.org',
        phone: '+91 98765 43210',
        location: 'Mumbai, Maharashtra',
        avatar: '',
        role: UserRole.superAdmin,
        assignedAdminId: null,
        skills: ['Leadership', 'Strategy', 'Finance', 'Governance'],
        joinedDate: DateTime(2020, 1, 15),
      ),
      // Admins
      UserModel(
        id: 'u002',
        name: 'Priya Sharma',
        email: 'admin@jayshreefoundation.org',
        phone: '+91 97654 32109',
        location: 'Delhi, NCR',
        avatar: '',
        role: UserRole.admin,
        assignedAdminId: 'u001',
        skills: ['Project Management', 'Community Outreach', 'Training'],
        joinedDate: DateTime(2020, 6, 1),
      ),
      UserModel(
        id: 'u003',
        name: 'Vikram Nair',
        email: 'vikram@jayshreefoundation.org',
        phone: '+91 96543 21098',
        location: 'Bengaluru, Karnataka',
        avatar: '',
        role: UserRole.admin,
        assignedAdminId: 'u001',
        skills: ['Operations', 'Logistics', 'Volunteer Coordination'],
        joinedDate: DateTime(2021, 2, 10),
      ),
      // Members
      UserModel(
        id: 'u004',
        name: 'Dr. Anjali Mehta',
        email: 'anjali@jayshreefoundation.org',
        phone: '+91 95432 10987',
        location: 'Chennai, Tamil Nadu',
        avatar: '',
        role: UserRole.member,
        assignedAdminId: 'u002',
        skills: ['Healthcare', 'Medical Aid', 'First Aid', 'Counselling'],
        joinedDate: DateTime(2021, 5, 20),
      ),
      UserModel(
        id: 'u005',
        name: 'Suresh Patel',
        email: 'suresh@jayshreefoundation.org',
        phone: '+91 94321 09876',
        location: 'Ahmedabad, Gujarat',
        avatar: '',
        role: UserRole.member,
        assignedAdminId: 'u002',
        skills: ['Fundraising', 'Community Engagement', 'Event Management'],
        joinedDate: DateTime(2021, 8, 3),
      ),
      UserModel(
        id: 'u006',
        name: 'Neha Singh',
        email: 'neha@jayshreefoundation.org',
        phone: '+91 93210 98765',
        location: 'Lucknow, Uttar Pradesh',
        avatar: '',
        role: UserRole.member,
        assignedAdminId: 'u003',
        skills: ['Education', 'Child Welfare', 'Social Work'],
        joinedDate: DateTime(2022, 1, 17),
      ),
      UserModel(
        id: 'u007',
        name: 'Rohan Gupta',
        email: 'rohan@jayshreefoundation.org',
        phone: '+91 92109 87654',
        location: 'Kolkata, West Bengal',
        avatar: '',
        role: UserRole.member,
        assignedAdminId: 'u003',
        skills: ['IT & Technology', 'Data Analysis', 'Digital Marketing'],
        joinedDate: DateTime(2022, 4, 22),
      ),
      // Volunteers
      UserModel(
        id: 'u008',
        name: 'Amit Verma',
        email: 'amit@jayshreefoundation.org',
        phone: '+91 91098 76543',
        location: 'Jaipur, Rajasthan',
        avatar: '',
        role: UserRole.volunteer,
        assignedAdminId: 'u002',
        skills: ['Teaching', 'Mentoring', 'Sports Coaching'],
        joinedDate: DateTime(2022, 7, 5),
      ),
      UserModel(
        id: 'u009',
        name: 'Kavya Reddy',
        email: 'kavya@jayshreefoundation.org',
        phone: '+91 90987 65432',
        location: 'Hyderabad, Telangana',
        avatar: '',
        role: UserRole.volunteer,
        assignedAdminId: 'u002',
        skills: ['Graphic Design', 'Content Creation', 'Photography'],
        joinedDate: DateTime(2022, 9, 12),
      ),
      UserModel(
        id: 'u010',
        name: 'Arjun Singh',
        email: 'arjun@jayshreefoundation.org',
        phone: '+91 89876 54321',
        location: 'Chandigarh, Punjab',
        avatar: '',
        role: UserRole.volunteer,
        assignedAdminId: 'u003',
        skills: ['Blood Donation Drives', 'First Aid', 'Rescue Operations'],
        joinedDate: DateTime(2023, 1, 8),
      ),
      UserModel(
        id: 'u011',
        name: 'Pooja Sharma',
        email: 'pooja@jayshreefoundation.org',
        phone: '+91 88765 43210',
        location: 'Pune, Maharashtra',
        avatar: '',
        role: UserRole.volunteer,
        assignedAdminId: 'u003',
        skills: ['Cooking', 'Food Distribution', 'Elder Care'],
        joinedDate: DateTime(2023, 3, 25),
      ),
      UserModel(
        id: 'u012',
        name: 'Deepak Kumar',
        email: 'deepak@jayshreefoundation.org',
        phone: '+91 87654 32109',
        location: 'Patna, Bihar',
        avatar: '',
        role: UserRole.volunteer,
        assignedAdminId: 'u002',
        skills: ['Carpentry', 'Construction', 'Repair & Maintenance'],
        joinedDate: DateTime(2023, 6, 14),
      ),
    ];
  }

  void _initTasks() {
    final now = DateTime.now();
    _tasks = [
      TaskModel(
        id: 't001',
        title: 'Organise Health Camp at Dharavi',
        description:
            'Coordinate with Dr. Anjali and local PHC to set up a free health screening camp. Arrange medical supplies, volunteers, and venue logistics.',
        assignedToId: 'u004',
        assignedById: 'u002',
        deadline: now.add(const Duration(days: 7)),
        createdAt: now.subtract(const Duration(days: 3)),
        status: TaskStatus.pending,
        requiresPhotoUpload: true,
      ),
      TaskModel(
        id: 't002',
        title: 'Prepare Annual Report 2024-25 Draft',
        description:
            'Compile all program reports, financial summaries, and impact metrics for the annual report. Submit draft to SuperAdmin by deadline.',
        assignedToId: 'u007',
        assignedById: 'u001',
        deadline: now.add(const Duration(days: 14)),
        createdAt: now.subtract(const Duration(days: 10)),
        status: TaskStatus.pending,
        requiresPhotoUpload: false,
      ),
      TaskModel(
        id: 't003',
        title: 'Distribute Notebooks to Government School - Govandi',
        description:
            'Collect 500 notebooks from store, arrange transport and distribute to students at Govandi Municipal School. Take photos for report.',
        assignedToId: 'u008',
        assignedById: 'u002',
        deadline: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 12)),
        status: TaskStatus.submitted,
        requiresPhotoUpload: true,
        photoUrl: 'https://example.com/photos/t003.jpg',
      ),
      TaskModel(
        id: 't004',
        title: 'Blood Donation Camp – Brigade Road',
        description:
            'Coordinate with Apollo Blood Bank to conduct a blood donation camp. Target: 50 units. Arrange refreshments and volunteer badges.',
        assignedToId: 'u010',
        assignedById: 'u003',
        deadline: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 5)),
        status: TaskStatus.approved,
        requiresPhotoUpload: true,
        photoUrl: 'https://example.com/photos/t004.jpg',
        adminComment: 'Excellent work! Camp was a great success.',
      ),
      TaskModel(
        id: 't005',
        title: 'Social Media Content for Diwali Drive',
        description:
            'Create 10 social media posts (Instagram + Facebook) for the Diwali gift distribution drive. Use Jayshree Foundation branding guidelines.',
        assignedToId: 'u009',
        assignedById: 'u002',
        deadline: now.add(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 2)),
        status: TaskStatus.pending,
        requiresPhotoUpload: false,
      ),
      TaskModel(
        id: 't006',
        title: 'Food Distribution – Old Age Home Visit',
        description:
            'Visit Shanti Niketan Old Age Home with 50 meal packages. Spend time with residents. Document the visit with photos and a brief report.',
        assignedToId: 'u011',
        assignedById: 'u003',
        deadline: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 15)),
        status: TaskStatus.rejected,
        requiresPhotoUpload: true,
        adminComment: 'Photos not uploaded. Please redo the visit and submit proper documentation.',
      ),
      TaskModel(
        id: 't007',
        title: 'Repair Community Library Furniture',
        description:
            'Assess and repair broken chairs and tables at the Govandi Community Library. Source materials from local supplier if needed.',
        assignedToId: 'u012',
        assignedById: 'u003',
        deadline: now.add(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(days: 1)),
        status: TaskStatus.pending,
        requiresPhotoUpload: true,
      ),
      TaskModel(
        id: 't008',
        title: 'MOU Follow-up with Tata Memorial Hospital',
        description:
            'Follow up with the MOU team at Tata Memorial Hospital regarding the pending patient support agreement. Submit meeting notes.',
        assignedToId: 'u005',
        assignedById: 'u001',
        deadline: now.add(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 4)),
        status: TaskStatus.submitted,
        requiresPhotoUpload: false,
      ),
      TaskModel(
        id: 't009',
        title: 'Conduct Tailoring Workshop – Govandi Women\'s Centre',
        description:
            'Lead a 3-day tailoring skills workshop for 20 women at Govandi Women\'s Centre. Arrange materials and certificates for participants.',
        assignedToId: 'u006',
        assignedById: 'u002',
        deadline: now.add(const Duration(days: 21)),
        createdAt: now.subtract(const Duration(days: 1)),
        status: TaskStatus.pending,
        requiresPhotoUpload: true,
      ),
      TaskModel(
        id: 't010',
        title: 'Update Volunteer Database',
        description:
            'Review and update all volunteer contact details, skill sets, and availability in the system. Remove inactive records.',
        assignedToId: 'u007',
        assignedById: 'u003',
        deadline: now.add(const Duration(days: 4)),
        createdAt: now.subtract(const Duration(days: 6)),
        status: TaskStatus.approved,
        requiresPhotoUpload: false,
        adminComment: 'Good work. Database is now up to date.',
      ),
    ];
  }

  void _initDonations() {
    _donations = [
      DonationModel(
        id: 'd001',
        donorName: 'Ramesh & Sunita Agarwal',
        purpose: 'Education Support Fund',
        amount: 150000,
        paymentMode: 'Cheque',
        date: DateTime(2024, 4, 5),
        is80GEligible: true,
        receiptGenerated: true,
      ),
      DonationModel(
        id: 'd002',
        donorName: 'Tata Consultancy Services CSR',
        purpose: 'Digital Literacy Programme',
        amount: 200000,
        paymentMode: 'Online',
        date: DateTime(2024, 5, 12),
        is80GEligible: true,
        receiptGenerated: true,
      ),
      DonationModel(
        id: 'd003',
        donorName: 'Mrs. Kamala Iyer',
        purpose: 'Medical Aid – Cancer Patients',
        amount: 50000,
        paymentMode: 'Online',
        date: DateTime(2024, 6, 20),
        is80GEligible: true,
        receiptGenerated: true,
      ),
      DonationModel(
        id: 'd004',
        donorName: 'Mahindra Foundation',
        purpose: 'Skill Development Workshops',
        amount: 125000,
        paymentMode: 'Online',
        date: DateTime(2024, 7, 3),
        is80GEligible: true,
        receiptGenerated: false,
      ),
      DonationModel(
        id: 'd005',
        donorName: 'Prakash Deshpande',
        purpose: 'Food Distribution Drive',
        amount: 25000,
        paymentMode: 'Cash',
        date: DateTime(2024, 8, 14),
        is80GEligible: false,
        receiptGenerated: true,
      ),
      DonationModel(
        id: 'd006',
        donorName: 'Rotary Club of Mumbai South',
        purpose: 'Blood Donation Camps',
        amount: 75000,
        paymentMode: 'Cheque',
        date: DateTime(2024, 9, 2),
        is80GEligible: true,
        receiptGenerated: true,
      ),
      DonationModel(
        id: 'd007',
        donorName: 'Anonymous Donor',
        purpose: 'General Corpus Fund',
        amount: 30000,
        paymentMode: 'Online',
        date: DateTime(2024, 10, 18),
        is80GEligible: false,
        receiptGenerated: true,
      ),
      DonationModel(
        id: 'd008',
        donorName: 'Wipro Cares',
        purpose: 'Women Empowerment Initiative',
        amount: 100000,
        paymentMode: 'Online',
        date: DateTime(2024, 11, 7),
        is80GEligible: true,
        receiptGenerated: false,
      ),
      DonationModel(
        id: 'd009',
        donorName: 'Sunil & Rekha Joshi',
        purpose: 'Scholarship Fund',
        amount: 60000,
        paymentMode: 'Cheque',
        date: DateTime(2024, 12, 22),
        is80GEligible: true,
        receiptGenerated: true,
      ),
      DonationModel(
        id: 'd010',
        donorName: 'Lions Club International – Pune',
        purpose: 'Elderly Care Programme',
        amount: 40000,
        paymentMode: 'Online',
        date: DateTime(2025, 1, 15),
        is80GEligible: true,
        receiptGenerated: true,
      ),
      DonationModel(
        id: 'd011',
        donorName: 'Rajendra Prasad Gupta',
        purpose: 'Rural Health Initiative',
        amount: 15000,
        paymentMode: 'Cash',
        date: DateTime(2025, 2, 8),
        is80GEligible: false,
        receiptGenerated: false,
      ),
      DonationModel(
        id: 'd012',
        donorName: 'HDFC Bank CSR Division',
        purpose: 'Community Infrastructure',
        amount: 135000,
        paymentMode: 'Online',
        date: DateTime(2025, 3, 1),
        is80GEligible: true,
        receiptGenerated: true,
      ),
      // Total ≈ ₹10,05,000
    ];
  }

  void _initMeetings() {
    final now = DateTime.now();
    _meetings = [
      // Upcoming
      MeetingModel(
        id: 'm001',
        title: 'Monthly Volunteer Coordination Meeting – April 2025',
        dateTime: now.add(const Duration(days: 5)),
        attendeeIds: ['u001', 'u002', 'u003', 'u004', 'u005', 'u006', 'u007'],
        status: MeetingStatus.scheduled,
      ),
      MeetingModel(
        id: 'm002',
        title: 'Board Review – Q4 2024-25 Impact Report',
        dateTime: now.add(const Duration(days: 12)),
        attendeeIds: ['u001', 'u002', 'u003'],
        status: MeetingStatus.scheduled,
      ),
      MeetingModel(
        id: 'm003',
        title: 'Planning Session – Diwali Community Drive 2025',
        dateTime: now.add(const Duration(days: 21)),
        attendeeIds: ['u002', 'u004', 'u005', 'u008', 'u009', 'u011'],
        status: MeetingStatus.scheduled,
      ),
      // Past
      MeetingModel(
        id: 'm004',
        title: 'Monthly Volunteer Coordination Meeting – March 2025',
        dateTime: now.subtract(const Duration(days: 28)),
        attendeeIds: ['u001', 'u002', 'u003', 'u004', 'u005', 'u006'],
        status: MeetingStatus.completed,
        momSummary:
            'Meeting chaired by Rajesh Kumar. Key decisions: (1) Approve ₹75,000 for health camp logistics. '
            '(2) Assign Diwali drive planning to Priya\'s team. (3) Review MOU with Tata Memorial Hospital next month. '
            '(4) Deepak Kumar to complete library repair by April 10. All action points recorded and distributed.',
        momSubmittedBy: 'u002',
      ),
      MeetingModel(
        id: 'm005',
        title: 'Annual General Body Meeting – FY 2024-25',
        dateTime: now.subtract(const Duration(days: 62)),
        attendeeIds: ['u001', 'u002', 'u003', 'u004', 'u005', 'u006', 'u007', 'u008'],
        status: MeetingStatus.completed,
        momSummary:
            'Annual General Body Meeting held successfully. Agenda: (1) Presentation of audited accounts for FY 2023-24. '
            '(2) Election of board members – Rajesh Kumar re-elected as President. '
            '(3) Approval of annual budget ₹28,50,000 for FY 2024-25. '
            '(4) Review of strategic plan 2025-2027. '
            '(5) Vote of thanks. Quorum present: 8 of 12 members.',
        momSubmittedBy: 'u003',
      ),
    ];
  }

  void _initMouRequests() {
    _mouRequests = [
      MouModel(
        id: 'mou001',
        patientName: 'Sanjay Ramchandra Pawar',
        disease: 'Acute Lymphoblastic Leukaemia (ALL)',
        hospitalName: 'Tata Memorial Hospital, Parel',
        bloodGroup: 'O+',
        phone: '+91 96543 78901',
        address: 'Chawl No. 4, Dharavi, Mumbai – 400017',
        submittedById: 'u005',
        patientAge: 8,
        submittedDate: DateTime.now().subtract(const Duration(days: 6)),
        status: MouStatus.pending,
      ),
      MouModel(
        id: 'mou002',
        patientName: 'Meena Devi Yadav',
        disease: 'End-Stage Renal Disease – Dialysis',
        hospitalName: 'AIIMS Delhi, New Delhi',
        bloodGroup: 'B+',
        phone: '+91 87654 23456',
        address: '12, Govindpuri Extension, New Delhi – 110019',
        submittedById: 'u006',
        patientAge: 52,
        submittedDate: DateTime.now().subtract(const Duration(days: 14)),
        status: MouStatus.approved,
      ),
      MouModel(
        id: 'mou003',
        patientName: 'Ravi Shankar Tiwari',
        disease: 'Coronary Artery Disease – Bypass Surgery',
        hospitalName: 'Narayana Health, Bengaluru',
        bloodGroup: 'A+',
        phone: '+91 77654 89012',
        address: '7/B, Rajajinagar 3rd Block, Bengaluru – 560010',
        submittedById: 'u004',
        patientAge: 61,
        submittedDate: DateTime.now().subtract(const Duration(days: 3)),
        status: MouStatus.pending,
      ),
    ];
  }

  void _initCertificates() {
    _certificates = [
      CertificateModel(
        id: 'c001',
        requestedById: 'u008',
        certificateType: 'Volunteer Service Certificate',
        additionalDetails:
            'For volunteering 120+ hours in Health Camps and Education Drives (Jan 2024 – Mar 2025).',
        requestedDate: DateTime.now().subtract(const Duration(days: 9)),
        status: RequestStatus.pending,
      ),
      CertificateModel(
        id: 'c002',
        requestedById: 'u009',
        certificateType: 'Certificate of Appreciation',
        additionalDetails:
            'Designed all social media campaigns and printed materials for the Diwali Drive 2024.',
        requestedDate: DateTime.now().subtract(const Duration(days: 20)),
        status: RequestStatus.approved,
      ),
      CertificateModel(
        id: 'c003',
        requestedById: 'u010',
        certificateType: 'Volunteer Service Certificate',
        additionalDetails: 'Organised 4 blood donation camps collecting 210 units in FY 2024-25.',
        requestedDate: DateTime.now().subtract(const Duration(days: 4)),
        status: RequestStatus.pending,
      ),
      CertificateModel(
        id: 'c004',
        requestedById: 'u011',
        certificateType: 'Letter of Recommendation',
        additionalDetails: 'Required for MSW admission application.',
        requestedDate: DateTime.now().subtract(const Duration(days: 30)),
        status: RequestStatus.rejected,
      ),
    ];
  }

  void _initDocuments() {
    _documents = [
      // LEGAL
      DocumentModel(
        id: 'doc001',
        name: 'NGO Registration Certificate',
        category: 'LEGAL',
        iconColor: 'purple',
        fileUrl: 'https://jayshreefoundation.org/docs/ngo_registration.pdf',
      ),
      DocumentModel(
        id: 'doc002',
        name: 'FCRA Registration Certificate',
        category: 'LEGAL',
        iconColor: 'purple',
        fileUrl: 'https://jayshreefoundation.org/docs/fcra_certificate.pdf',
      ),
      // TAX
      DocumentModel(
        id: 'doc003',
        name: '12A Tax Exemption Certificate',
        category: 'TAX',
        iconColor: 'orange',
        fileUrl: 'https://jayshreefoundation.org/docs/12a_certificate.pdf',
      ),
      DocumentModel(
        id: 'doc004',
        name: '80G Certificate',
        category: 'TAX',
        iconColor: 'orange',
        fileUrl: 'https://jayshreefoundation.org/docs/80g_certificate.pdf',
      ),
      // REPORTS
      DocumentModel(
        id: 'doc005',
        name: 'Annual Report 2023-24',
        category: 'REPORTS',
        iconColor: 'teal',
        fileUrl: 'https://jayshreefoundation.org/docs/annual_report_2324.pdf',
      ),
      // FINANCIAL
      DocumentModel(
        id: 'doc006',
        name: 'Audited Financial Statements FY 2023-24',
        category: 'FINANCIAL',
        iconColor: 'blue',
        fileUrl: 'https://jayshreefoundation.org/docs/audited_statements_2324.pdf',
      ),
      DocumentModel(
        id: 'doc007',
        name: 'Donor List 2024-25',
        category: 'FINANCIAL',
        iconColor: 'blue',
      ),
      // GOVERNANCE
      DocumentModel(
        id: 'doc008',
        name: 'Board Resolution – March 2025',
        category: 'GOVERNANCE',
        iconColor: 'red',
        fileUrl: 'https://jayshreefoundation.org/docs/board_resolution_mar25.pdf',
      ),
    ];
  }

  void _initJoiningLetters() {
    _joiningLetters = [
      JoiningLetterModel(
        id: 'jl001',
        requestedById: 'u008',
        tenureType: 'Monthly',
        requestedDate: DateTime.now().subtract(const Duration(days: 8)),
        month: 'March',
        year: '2025',
        generatedById: 'u002',
        status: RequestStatus.approved,
      ),
      JoiningLetterModel(
        id: 'jl002',
        requestedById: 'u010',
        tenureType: 'Annual',
        requestedDate: DateTime.now().subtract(const Duration(days: 5)),
        year: '2024-25',
        status: RequestStatus.pending,
      ),
      JoiningLetterModel(
        id: 'jl003',
        requestedById: 'u011',
        tenureType: 'Monthly',
        requestedDate: DateTime.now().subtract(const Duration(days: 3)),
        month: 'April',
        year: '2025',
        status: RequestStatus.pending,
      ),
      JoiningLetterModel(
        id: 'jl004',
        requestedById: 'u009',
        tenureType: 'Annual',
        requestedDate: DateTime.now().subtract(const Duration(days: 45)),
        year: '2023-24',
        generatedById: 'u003',
        status: RequestStatus.approved,
      ),
    ];
  }
}
