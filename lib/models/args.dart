import 'package:json_annotation/json_annotation.dart';

import 'auths/user_model.dart';

part 'args.g.dart';

@JsonSerializable()
class Args {
  Args({
    this.isBroadcaster,
    required this.broadcaster,
    required this.callType,
  });

  @JsonKey(name: 'is_broadcaster')
  final bool? isBroadcaster;
  final User? broadcaster;

  @JsonKey(name: 'call_type')
  final CallType callType;

  Args copyWith({
    bool? isBroadcaster,
    User? broadcaster,
    required CallType callType,
  }) {
    return Args(
      isBroadcaster: isBroadcaster ?? this.isBroadcaster,
      broadcaster: broadcaster ?? this.broadcaster,
      callType: callType ?? CallType.outgoing,
    );
  }

  factory Args.fromJson(Map<String, dynamic> json) => _$ArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ArgsToJson(this);

}

