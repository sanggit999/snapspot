import 'package:snapspot/features/auth/domain/entities/user_entity.dart';
import 'package:snapspot/features/feed/domain/entities/post_entity.dart';
import 'package:snapspot/features/chat/domain/entities/chat_entity.dart';

/// Dữ liệu giả lập chất lượng cao phục vụ cho phát triển Frontend của SnapSpot.
/// Đặt tại thư mục chuyên biệt lib/core/mock/mock_data.dart chuẩn Clean Architecture & mock-data-rules.
class MockData {
  // 1. Danh sách Users giả lập
  static final List<UserEntity> mockUsers = [
    const UserEntity(
      id: 'usr_1',
      email: 'sangnguyen@example.com',
      username: 'sangnguyen',
      fullName: 'Nguyễn Văn Sang',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      bio:
          'Đam mê nhiếp ảnh phong cảnh và du lịch trải nghiệm. Thích check-in bản đồ!',
      isPrivate: false,
      postsCount: 12,
      followersCount: 1450,
      followingCount: 382,
    ),
    const UserEntity(
      id: 'usr_2',
      email: 'lananh@example.com',
      username: 'lananh_traveler',
      fullName: 'Trần Lan Anh',
      avatarUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80',
      bio:
          'Travel Blogger ✈️ | Chia sẻ những khoảnh khắc đẹp quanh Việt Nam 🇻🇳',
      isPrivate: false,
      postsCount: 24,
      followersCount: 5200,
      followingCount: 890,
    ),
    const UserEntity(
      id: 'usr_3',
      email: 'minhquan@example.com',
      username: 'quan_explorer',
      fullName: 'Lê Minh Quân',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      bio:
          'Cà phê bụi, phượt xe máy 🏍️. Thích khám phá những góc khuất Hà Nội.',
      isPrivate: true,
      postsCount: 8,
      followersCount: 240,
      followingCount: 420,
    ),
    const UserEntity(
      id: 'usr_4',
      email: 'hoangnam@example.com',
      username: 'nam_outdoor',
      fullName: 'Phạm Hoàng Nam',
      avatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
      bio: 'Nature & Adventure photographer. Hiking lover 🧗‍♂️.',
      isPrivate: false,
      postsCount: 42,
      followersCount: 8400,
      followingCount: 512,
    ),
    const UserEntity(
      id: 'usr_5',
      email: 'thuychi@example.com',
      username: 'thuychi_art',
      fullName: 'Nguyễn Thùy Chi',
      avatarUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
      bio: 'Họa sĩ tự do 🎨. Yêu thích sắc màu cuộc sống qua từng góc ảnh.',
      isPrivate: false,
      postsCount: 15,
      followersCount: 1200,
      followingCount: 290,
    ),
  ];

  // 2. Danh sách Posts giả lập kèm toạ độ GPS tại Việt Nam (Ảnh Unsplash HD sống động)
  static final List<PostEntity> mockPosts = [
    PostEntity(
      id: 'post_1',
      caption:
          'Buổi sáng trong lành tại Hồ Hoàn Kiếm, ngắm Tháp Rùa cổ kính mờ sương. Yêu Hà Nội những ngày thu dịu mát! #hanoi #hoankiem #autumn #photography',
      imageUrls: const [
        'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=80',
      ],
      latitude: 21.0285,
      longitude: 105.8542,
      locationName: 'Hồ Hoàn Kiếm, Hà Nội',
      user: mockUsers[1], // Trần Lan Anh
      hashtags: const ['hanoi', 'hoankiem', 'autumn', 'photography'],
      likesCount: 15400, // 15.4K Likes
      commentsCount: 1250, // 1.3K Comments
      sharesCount: 3200, // 3.2K Shares
      isLiked: true,
      userReaction: '🔥',
      isBookmarked: true,
      savedCollectionName: 'Địa điểm muốn đến',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      comments: [
        CommentEntity(
          id: 'c_1',
          postId: 'post_1',
          user: mockUsers[0], // Nguyễn Văn Sang (Root)
          content:
              'Ảnh chụp đẹp quá bạn ơi! Mùa thu Hà Nội luôn có chất riêng.',
          likesCount: 520, // 520 Likes
          isLiked: true,
          isPinned: true, // Ghim bình luận nổi bật
          createdAt: DateTime.now().subtract(
            const Duration(hours: 2, minutes: 30),
          ),
          replies: [
            CommentEntity(
              id: 'c_1_1',
              postId: 'post_1',
              parentId: 'c_1',
              user: mockUsers[1], // Trần Lan Anh
              replyToUser: mockUsers[0], // Nguyễn Văn Sang
              content:
                  'Cảm ơn anh Sang nhiều nhé! Hà Nội mùa này thời tiết thích lắm ạ. ✨',
              likesCount: 142,
              isLiked: true,
              createdAt: DateTime.now().subtract(
                const Duration(hours: 2, minutes: 15),
              ),
            ),
            CommentEntity(
              id: 'c_1_2',
              postId: 'post_1',
              parentId: 'c_1_1',
              user: mockUsers[2], // Lê Minh Quân
              replyToUser: mockUsers[1], // Trần Lan Anh
              content: 'Khi nào ra Hà Nội cho mình đi check-in ké với nha!',
              likesCount: 18,
              isLiked: false,
              createdAt: DateTime.now().subtract(
                const Duration(hours: 2),
              ),
            ),
            CommentEntity(
              id: 'c_1_3',
              postId: 'post_1',
              parentId: 'c_1',
              user: mockUsers[3], // Phạm Hoàng Nam
              replyToUser: mockUsers[0], // Nguyễn Văn Sang
              content: 'Thời tiết Hà Nội mùa thu đúng là mê đắm lòng người.',
              likesCount: 89,
              isLiked: true,
              createdAt: DateTime.now().subtract(
                const Duration(hours: 1, minutes: 45),
              ),
            ),
            CommentEntity(
              id: 'c_1_4',
              postId: 'post_1',
              parentId: 'c_1',
              user: mockUsers[4], // Nguyễn Thùy Chi
              replyToUser: mockUsers[1], // Trần Lan Anh
              content: 'Hồ Gươm sương mờ sáng sớm nhìn lãng mạn quá ạ! 🍂',
              likesCount: 34,
              isLiked: false,
              createdAt: DateTime.now().subtract(
                const Duration(hours: 1, minutes: 30),
              ),
            ),
            CommentEntity(
              id: 'c_1_5',
              postId: 'post_1',
              parentId: 'c_1_4',
              user: mockUsers[1], // Trần Lan Anh
              replyToUser: mockUsers[4], // Nguyễn Thùy Chi
              content: 'Hôm nào có dịp mình mời mọi người cà phê trứng nhé! ☕',
              likesCount: 205,
              isLiked: true,
              createdAt: DateTime.now().subtract(
                const Duration(hours: 1, minutes: 15),
              ),
            ),
          ],
        ),
        CommentEntity(
          id: 'c_2',
          postId: 'post_1',
          user: mockUsers[4], // Nguyễn Thùy Chi
          content: 'Thích màu ảnh nhẹ nhàng này thế! Chụp bằng máy gì vậy ạ?',
          likesCount: 78,
          isLiked: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    ),
    PostEntity(
      id: 'post_2',
      caption:
          'Nhà thờ Đức Bà Sài Gòn chiều cuối tuần. Dù đang trùng tu nhưng vẫn mang đậm nét kiến trúc Gothic tráng lệ giữa lòng thành phố. #saigon #district1 #nhathoducba #citylife',
      imageUrls: const [
        'https://images.unsplash.com/photo-1583417319070-4a69db38a482?auto=format&fit=crop&w=1000&q=80',
      ],
      latitude: 10.7769,
      longitude: 106.7009,
      locationName: 'Nhà thờ Đức Bà, Quận 1, TP. HCM',
      user: mockUsers[3], // Phạm Hoàng Nam
      hashtags: const ['saigon', 'district1', 'nhathoducba', 'citylife'],
      likesCount: 1200000, // 1.2M Likes
      commentsCount: 34500, // 34.5K Comments
      sharesCount: 15400, // 15.4K Shares
      isLiked: true,
      userReaction: '😍',
      isBookmarked: true,
      savedCollectionName: 'Quán cà phê đẹp',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      comments: [
        CommentEntity(
          id: 'c_4',
          postId: 'post_2',
          user: mockUsers[1],
          content: 'Tuyệt quá anh! Hy vọng công trình sớm hoàn thành trùng tu.',
          likesCount: 1500,
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        ),
        CommentEntity(
          id: 'c_5',
          postId: 'post_2',
          user: mockUsers[0],
          content: 'Góc chụp rất rộng và hùng vĩ!',
          likesCount: 840,
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        ),
      ],
    ),
    PostEntity(
      id: 'post_3',
      caption:
          'Phố cổ Hội An lung linh sắc màu lồng đèn khi màn đêm buông xuống. Đi thuyền trên sông Hoài thả hoa đăng cầu bình an. #hoian_oldtown & #danang #travelvietnam',
      imageUrls: const [
        'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=1000&q=80',
      ],
      latitude: 15.8801,
      longitude: 108.3380,
      locationName: 'Phố cổ Hội An, Quảng Nam',
      user: mockUsers[0], // Nguyễn Văn Sang (Chính mình)
      hashtags: const ['hoian_oldtown', 'danang', 'travelvietnam'],
      likesCount: 450,
      commentsCount: 1,
      sharesCount: 45,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      comments: [
        CommentEntity(
          id: 'c_6',
          postId: 'post_3',
          user: mockUsers[4],
          content: 'Phố cổ thơ mộng quá, ước gì được quay lại đây lần nữa.',
          createdAt: DateTime.now().subtract(
            const Duration(days: 1, hours: 22),
          ),
        ),
      ],
    ),
    PostEntity(
      id: 'post_4',
      caption:
          'Săn mây thành công tại đỉnh đồi chè Cầu Đất, Đà Lạt! Nhiệt độ lúc 5h sáng chỉ 14 độ C, buốt giá nhưng bù lại là khung cảnh tiên cảnh. ☁️🌲 #dalat #travel #caudat #sanamay',
      imageUrls: const [
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1511884642898-4c92249e20b6?auto=format&fit=crop&w=1000&q=80',
      ],
      latitude: 11.9404,
      longitude: 108.4583,
      locationName: 'Đồi chè Cầu Đất, Đà Lạt',
      user: mockUsers[4], // Nguyễn Thùy Chi
      hashtags: const ['dalat', 'travel', 'caudat', 'sanamay'],
      likesCount: 42500, // 42.5K Likes
      commentsCount: 890,
      sharesCount: 890,
      isLiked: true,
      userReaction: '📍',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      comments: [
        CommentEntity(
          id: 'c_7',
          postId: 'post_4',
          user: mockUsers[1],
          content: 'Chuyến này đi săn mây quá ưng ý luôn bạn ơi!',
          createdAt: DateTime.now().subtract(
            const Duration(days: 2, hours: 20),
          ),
        ),
        CommentEntity(
          id: 'c_8',
          postId: 'post_4',
          user: mockUsers[3],
          content: 'Mây dày dặn và đẹp quá, đợt trước mình đi xịt mất tiêu 😂.',
          createdAt: DateTime.now().subtract(
            const Duration(days: 2, hours: 18),
          ),
        ),
      ],
    ),
    PostEntity(
      id: 'post_5',
      caption:
          'Thung lũng Mường Hoa, Sa Pa mùa lúa chín vàng óng ả trải dài trên những thửa ruộng bậc thang. Một vẻ đẹp kỳ vĩ của thiên nhiên Tây Bắc! #sapa #ruongbacthang #taybac #vietnam',
      imageUrls: const [
        'https://images.unsplash.com/photo-1544735716-392fe2489ffa?auto=format&fit=crop&w=1000&q=80',
      ],
      latitude: 22.3364,
      longitude: 103.8438,
      locationName: 'Thung lũng Mường Hoa, Sa Pa, Lào Cai',
      user: mockUsers[2], // Lê Minh Quân
      hashtags: const ['sapa', 'ruongbacthang', 'taybac', 'vietnam'],
      likesCount: 2300000000, // 2.3B Likes
      commentsCount: 15600, // 15.6K Comments
      sharesCount: 520000, // 520K Shares
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      comments: const [],
    ),
  ];

  // 3. Danh sách cuộc hội thoại và tin nhắn giả lập
  static final List<ChatRoomEntity> mockChatRooms = [
    ChatRoomEntity(
      id: 'room_1',
      partner: mockUsers[1], // Trần Lan Anh
      lastMessage: MessageEntity(
        id: 'msg_3',
        senderId: 'usr_2',
        content: 'Tuyệt quá, vậy hẹn cuối tuần này nhé!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      unreadCount: 2,
      messages: [
        MessageEntity(
          id: 'msg_1',
          senderId: 'usr_1',
          content: 'Chào Lan Anh, mình rất thích các bộ ảnh du lịch của bạn!',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        MessageEntity(
          id: 'msg_2',
          senderId: 'usr_2',
          content:
              'Cảm ơn Sang nhé! Mình cũng thấy bạn chụp phong cảnh rất đẹp.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        MessageEntity(
          id: 'msg_3',
          senderId: 'usr_2',
          content: 'Tuyệt quá, vậy hẹn cuối tuần này nhé!',
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ],
    ),
    ChatRoomEntity(
      id: 'room_2',
      partner: mockUsers[3], // Phạm Hoàng Nam
      lastMessage: MessageEntity(
        id: 'msg_5',
        senderId: 'usr_3',
        content:
            'Bạn dùng ống kính gì để chụp bức ảnh góc rộng ở nhà thờ Đức Bà vậy?',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      unreadCount: 0,
      messages: [
        MessageEntity(
          id: 'msg_4',
          senderId: 'usr_1',
          content: 'Hi Nam! Bức ảnh Sài Gòn hôm qua bạn chụp ở góc nào thế?',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        MessageEntity(
          id: 'msg_5',
          senderId: 'usr_3',
          content:
              'Bạn dùng ống kính gì để chụp bức ảnh góc rộng ở nhà thờ Đức Bà vậy?',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
    ),
  ];
}
