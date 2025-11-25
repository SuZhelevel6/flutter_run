/// Result 类型: 表示操作的成功或失败
///
/// 使用 sealed class 确保只有 Success 和 Failure 两种子类
/// 这样编译器可以检查是否穷尽了所有情况
///
/// 示例:
/// ```dart
/// Future<Result<List<User>>> getUsers() async {
///   try {
///     final users = await api.fetchUsers();
///     return Success(users);
///   } catch (e) {
///     return Failure(NetworkFailure(e.toString()));
///   }
/// }
///
/// // 使用
/// final result = await repository.getUsers();
/// result.when(
///   success: (users) => print('成功: $users'),
///   failure: (error) => print('失败: ${error.message}'),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// 使用 when 方法处理成功和失败两种情况
  ///
  /// 这是最常用的方法,强制你处理成功和失败两种情况
  ///
  /// 示例:
  /// ```dart
  /// result.when(
  ///   success: (data) => setState(() => _data = data),
  ///   failure: (error) => showError(error.message),
  /// );
  /// ```
  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure error) failure,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Failure(:final error) => failure(error),
    };
  }

  /// 判断是否成功
  bool get isSuccess => this is Success<T>;

  /// 判断是否失败
  bool get isFailure => this is Failure<T>;

  /// 获取数据 (成功时有值,失败时为 null)
  ///
  /// 示例:
  /// ```dart
  /// final data = result.dataOrNull;
  /// if (data != null) {
  ///   print('数据: $data');
  /// }
  /// ```
  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  /// 获取错误 (失败时有值,成功时为 null)
  ///
  /// 示例:
  /// ```dart
  /// final error = result.errorOrNull;
  /// if (error != null) {
  ///   print('错误: ${error.message}');
  /// }
  /// ```
  AppFailure? get errorOrNull => switch (this) {
        Success() => null,
        Failure(:final error) => error,
      };

  /// map: 转换成功时的数据
  ///
  /// 如果是成功状态,转换数据并返回新的 Success
  /// 如果是失败状态,直接返回原 Failure
  ///
  /// 示例:
  /// ```dart
  /// final result = await repository.getUsers();
  /// final namesResult = result.map((users) => users.map((u) => u.name).toList());
  /// ```
  Result<R> map<R>(R Function(T data) transform) {
    return when(
      success: (data) => Success(transform(data)),
      failure: (error) => Failure(error),
    );
  }

  /// flatMap: 链式调用多个返回 Result 的操作
  ///
  /// 用于串联多个可能失败的操作
  ///
  /// 示例:
  /// ```dart
  /// final result = await repository.getUser(userId)
  ///   .flatMap((user) => repository.getUserPosts(user.id))
  ///   .flatMap((posts) => repository.getPostComments(posts.first.id));
  /// ```
  Future<Result<R>> flatMap<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    return when(
      success: (data) => transform(data),
      failure: (error) => Failure(error),
    );
  }

  /// getOrElse: 获取数据,失败时返回默认值
  ///
  /// 示例:
  /// ```dart
  /// final users = result.getOrElse([]);  // 失败时返回空列表
  /// ```
  T getOrElse(T defaultValue) {
    return when(
      success: (data) => data,
      failure: (_) => defaultValue,
    );
  }

  /// fold: 同时处理成功和失败,返回统一类型
  ///
  /// 与 when 类似,但命名更符合函数式编程习惯
  ///
  /// 示例:
  /// ```dart
  /// final message = result.fold(
  ///   onSuccess: (data) => '成功: $data',
  ///   onFailure: (error) => '失败: ${error.message}',
  /// );
  /// ```
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppFailure error) onFailure,
  }) {
    return when(success: onSuccess, failure: onFailure);
  }
}

/// Success: 表示操作成功
///
/// 包含成功时的数据
class Success<T> extends Result<T> {
  /// 成功时的数据
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Failure: 表示操作失败
///
/// 包含失败时的错误信息
class Failure<T> extends Result<T> {
  /// 失败时的错误
  final AppFailure error;

  const Failure(this.error);

  @override
  String toString() => 'Failure(error: $error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}

/// AppFailure: 所有错误的基类
///
/// 定义在这里是为了避免循环依赖
/// 具体的 Failure 类型在 core/error/failures.dart 中定义
abstract class AppFailure {
  final String message;
  const AppFailure(this.message);

  @override
  String toString() => '$runtimeType(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppFailure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
