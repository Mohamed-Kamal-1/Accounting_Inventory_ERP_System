import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/add_contact_usecase.dart';
import '../../domain/usecases/delete_contact_usecase.dart';
import '../../domain/usecases/get_contacts_usecase.dart';
import '../../domain/usecases/update_contact_usecase.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

@injectable
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final GetContactsUseCase _getContactsUseCase;
  final AddContactUseCase _addContactUseCase;
  final DeleteContactUseCase _deleteContactUseCase;
  final UpdateContactUseCase _updateContactUseCase;

  ContactsBloc(
    this._getContactsUseCase,
    this._addContactUseCase,
    this._deleteContactUseCase,
    this._updateContactUseCase,
  ) : super(ContactsInitial()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
    on<DeleteContactEvent>(_onDeleteContact);
    on<UpdateContactEvent>(_onUpdateContact);
    on<SearchContactsEvent>(_onSearchContacts);
  }

  Future<void> _onLoadContacts(
      LoadContactsEvent event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    final result = await _getContactsUseCase();
    result.fold(
      onFailure: (failure) => emit(ContactsError(failure.message)),
      onSuccess: (contacts) => emit(
          ContactsLoaded(allContacts: contacts, filteredContacts: contacts)),
    );
  }

  Future<void> _onAddContact(
      AddContactEvent event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    final result = await _addContactUseCase(event.contact,
        email: event.email, password: event.password);
    result.fold(
      onFailure: (failure) => emit(ContactsError(failure.message)),
      onSuccess: (_) {
        emit(const ContactsActionSuccess('تمت إضافة الجهة بنجاح'));
        add(LoadContactsEvent());
      },
    );
  }

  Future<void> _onUpdateContact(
      UpdateContactEvent event, Emitter<ContactsState> emit) async {
    final currentState = state;
    emit(ContactsLoading());
    final result = await _updateContactUseCase(event.contact);
    result.fold(
      onFailure: (failure) => emit(ContactsError(failure.message)),
      onSuccess: (_) {
        emit(const ContactsActionSuccess('تم تحديث بيانات الجهة بنجاح'));
        add(LoadContactsEvent());
      },
    );
  }

  Future<void> _onDeleteContact(
      DeleteContactEvent event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    final result = await _deleteContactUseCase(event.id);
    result.fold(
      onFailure: (failure) => emit(ContactsError(failure.message)),
      onSuccess: (_) {
        emit(const ContactsActionSuccess('تم حذف الجهة بنجاح'));
        add(LoadContactsEvent());
      },
    );
  }

  void _onSearchContacts(
      SearchContactsEvent event, Emitter<ContactsState> emit) {
    if (state is ContactsLoaded) {
      final currentState = state as ContactsLoaded;
      final query = event.query.toLowerCase().trim();

      if (query.isEmpty) {
        emit(ContactsLoaded(
            allContacts: currentState.allContacts,
            filteredContacts: currentState.allContacts));
        return;
      }

      final filtered = currentState.allContacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
            contact.phone.contains(query) ||
            contact.area.toLowerCase().contains(query);
      }).toList();

      emit(ContactsLoaded(
          allContacts: currentState.allContacts, filteredContacts: filtered));
    }
  }
}
