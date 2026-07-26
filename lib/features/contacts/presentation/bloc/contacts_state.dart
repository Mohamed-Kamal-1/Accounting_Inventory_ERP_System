import 'package:equatable/equatable.dart';

import '../../domain/entities/contact_entity.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactEntity> allContacts;
  final List<ContactEntity> filteredContacts;

  const ContactsLoaded(
      {required this.allContacts, required this.filteredContacts});

  @override
  List<Object?> get props => [allContacts, filteredContacts];
}

class ContactsActionSuccess extends ContactsState {
  final String message;

  const ContactsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactsError extends ContactsState {
  final String errorMessage;

  const ContactsError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
