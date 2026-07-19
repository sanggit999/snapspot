# 08 - State Management

Tài liệu này quy chuẩn hóa cách thức quản lý trạng thái (State Management) trong ứng dụng Flutter của SnapSpot bằng thư viện **flutter_bloc** (tập trung vào mô hình **Cubit**).

---

## 1. Tại sao chọn BLoC / Cubit?
BLoC (Business Logic Component) giúp tách biệt hoàn toàn phần giao diện (UI) và logic nghiệp vụ (Business Logic):
- **Phân tách trách nhiệm rõ ràng**: Giao diện chỉ nhận dữ liệu hiển thị (State) và gửi hành vi hành động (Methods/Events).
- **Trạng thái bất biến (Immutable State)**: Đảm bảo dữ liệu không bị thay đổi ngoài ý muốn ở nhiều nơi.
- **Dễ dàng kiểm thử (Testability)**: Có thể viết unit test cho Cubit bằng cách kiểm tra chuỗi các trạng thái phát ra (emitted states) một cách tuần tự thông qua thư viện `bloc_test`.

---

## 2. Quy chuẩn thiết kế Trạng thái (State Modeling)

Để tránh lỗi và đồng bộ giao diện, mọi màn hình hoặc tính năng sử dụng Cubit đều phải định nghĩa Trạng thái (State) dưới dạng các lớp con kế thừa từ một lớp trạng thái cơ sở (Base State) hoặc sử dụng thư viện **freezed** để sinh tự động mã nguồn.

### Ví dụ mô hình State cho Feed Screen (Sử dụng Freezed):
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/post.dart';

part 'feed_state.freezed.dart';

@freezed
class FeedState with _$FeedState {
  const factory FeedState.initial() = _Initial;
  const factory FeedState.loading() = _Loading;
  const factory FeedState.loaded(List<Post> posts) = _Loaded;
  const factory FeedState.error(String message) = _Error;
}
```

---

## 3. Quy chuẩn viết Cubit (Business Logic)

Lập trình viên sử dụng **Cubit** cho hầu hết các tác vụ quản lý trạng thái màn hình thông thường vì tính đơn giản, ít boilerplate code hơn BLoC. BLoC chỉ dùng khi có nghiệp vụ xử lý dòng dữ liệu phức tạp hoặc cần tối ưu hóa nâng cao.

### Ví dụ triển khai `FeedCubit`:
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/fetch_feed_usecase.dart';
import 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final FetchFeedUseCase _fetchFeedUseCase;

  FeedCubit(this._fetchFeedUseCase) : super(const FeedState.initial());

  Future<void> fetchFeed() async {
    emit(const FeedState.loading());
    try {
      final posts = await _fetchFeedUseCase.execute();
      emit(FeedState.loaded(posts));
    } catch (e) {
      emit(FeedState.error(e.toString()));
    }
  }
}
```

---

## 4. Tích hợp và Lắng nghe Trạng thái tại Giao diện (UI Integration)

### 4.1. Cung cấp Cubit (`BlocProvider`)
Cung cấp Cubit cho cây Widget con bằng `BlocProvider`. Nên khởi chạy Cubit ngay khi được khởi tạo.
```dart
BlocProvider(
  create: (context) => FeedCubit(context.read<FetchFeedUseCase>())..fetchFeed(),
  child: const FeedView(),
)
```

### 4.2. Lắng nghe và vẽ lại giao diện (`BlocBuilder` & `BlocConsumer`)
- **`BlocBuilder`**: Dùng khi chỉ cần vẽ lại giao diện dựa trên State.
```dart
BlocBuilder<FeedCubit, FeedState>(
  builder: (context, state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded: (posts) => ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(post: posts[index]),
      ),
      error: (msg) => Center(child: Text(msg)),
    );
  },
)
```
- **`BlocListener` / `BlocConsumer`**: Dùng khi cần thực hiện các hành động một lần duy nhất (side-effects) như hiển thị Dialog thông báo, Toast lỗi hoặc chuyển màn hình khi trạng thái thay đổi.

### 4.3. Gọi hành động (`context.read`)
Sử dụng `context.read<Cubit>()` trong các sự kiện callback (như `onPressed` của Button) để kích hoạt phương thức trong Cubit:
```dart
ElevatedButton(
  onPressed: () {
    context.read<FeedCubit>().fetchFeed();
  },
  child: const Text('Tải lại'),
)
```