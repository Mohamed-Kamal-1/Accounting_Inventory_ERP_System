import 'package:equatable/equatable.dart';

import '../../domain/entities/contact_entity.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object?> get props => [];
}

class LoadContactsEvent extends ContactsEvent {}

class AddContactEvent extends ContactsEvent {
  final ContactEntity contact;
  final String? email;
  final String? password;

  const AddContactEvent({required this.contact, this.email, this.password});

  @override
  List<Object?> get props => [contact, email, password];
}

class DeleteContactEvent extends ContactsEvent {
  final String id;

  const DeleteContactEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateContactEvent extends ContactsEvent {
  final ContactEntity contact;
  const UpdateContactEvent(this.contact);
  @override
  List<Object?> get props => [contact];
}

class SearchContactsEvent extends ContactsEvent {
  final String query;
  const SearchContactsEvent(this.query);
  @override
  List<Object?> get props => [query];
}
