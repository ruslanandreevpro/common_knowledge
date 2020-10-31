class WelcomeScreenMessages {
  static const String title = 'Добро пожаловать';
  static const String message =
      '«...Любовь всё покрывает, всему верит, всегда надеется, любовь всё переносит, никогда не прекращается, даже если все языки умолкнут и всё знание исчезнет».';
  static const String author = 'Лев Клыков';
  static const String authorDegree = 'доктор психологических наук,';
  static const String authorGrade = 'профессор, академик, целитель';
  static const String startButtonText = 'Начать';
  static const String signInButtonText = 'Войти';
  static const String alertDialogTitleText =
      'Хотите создать бесплатную учетную запись?';
  static const String alertDialogContentText =
      'С учетной записью Ваши данные будут надежно сохранены, что позволит Вам получить доступ к ним с нескольких устройств';
  static const String alertDialogPrimaryButtonText = 'Зарегистрироваться';
  static const String alertDialogSecondaryButtonText = 'Позже';
}

class AuthenticateScreensMessages {
  static const String signUpTitle = 'Новый пользователь';
  static const String signInTitle = 'Личный кабинет';
  static const String forgotPasswordTitle = 'Новый пароль';
  static const String userNameHintText = 'Ваше имя';
  static const String userEmailHintText = 'Адрес электронной почты';
  static const String userPasswordHintText = 'Пароль';
  static const String signUpButtonText = 'Регистрация';
  static const String signInButtonText = 'Войти';
  static const String forgotPasswordButtonText = 'Сбросить';
  static const String alreadyHaveAccountText = 'Уже есть учетная запись?';
  static const String createAccountText = 'Нет учетной записи?';
  static const String forgotPasswordText = 'Забыли пароль?';
  static const String cancelResetPasswordText = 'Вспомнили пароль?';
  static const String passwordResetLinkHasBeenSent =
      'Ссылка для сброса пароля была отправлена на указанный адрес электронной почты';
  static const String dividerText = 'ИЛИ';
}

class DiagnosticScreenMessages {
  static const String refBookForDiagnosticID = 'UiWZsgOwxyHgI5eOxpoW';
  static const String newDiagnosticTextTitle = 'Новая диагностика';
  static const String editDiagnosticTextTitle = 'Редактирование карты';
  static const String defaultDiagnosticTitleText = 'Диагностическая карта';
  static const String diagnosticCardSettingsTitleText =
      'Параметры диагностической карты';
  static const String diagnosticCardTitleHintText = 'Название карты';
  static const String diagnosticCardNotesHintText = 'Заметки';
  static const String diagnosticCardDateHintText = 'Дата проведения';
  static const String diagnosticCardClientHintText = 'Выберите клиента';
  static const String diagnosticCardSaveSettingsButtonText = 'Применить';
  static const String diagnosticCardInputPointTextTitle = 'Введите значение';
  static const String popupMenuClientsItemText = 'Клиент';
  static const String popupMenuCardTitleItemText = 'Название карты';
  static const String popupMenuCardDateItemText = 'Дата диагностики';
  static const String popupMenuCardNotesItemText = 'Заметки';
  static const String popupMenuRandomDataItemText = 'Автозаполнение';
  static const String drawerHeaderText = 'Выберите клиента';
}

class ClientsScreenMessages {
  static const String newClientTextTitle = 'Новый клиент';
  static const String clientNameHintText = 'Имя клиента';
  static const String clientEmailHintText = 'Адрес электронной почты';
  static const String clientBirthDateHintText = 'Дата рождения';
  static const String clientBirthPlaceHintText = 'Место рождения';
  static const String clientPhoneNumberHintText = 'Контактный номер';
  static const String clientPhotoHintText = 'Фото';
  static const String clientAddButtonText = 'Добавить';
  static const String clientSaveButtonText = 'Сохранить';
  static const String viewRefBookTextTitle = 'Справочник';
}

class DashboardScreenMessages {
  static const String iconButtonTextTitleNewRecord = 'Новый\nсправочник';
  static const String iconButtonTextTitleNewClient = 'Новый\nклиент';
  static const String iconButtonTextTitleNewDiagnostic = 'Новая\nдиагностика';
  static const String iconButtonTextTitleNewReport = 'Новый\nотчет';
  static const String dateTitle = 'Сегодня';
  static const String recordsCardTitle = 'Справочники';
  static const String clientsCardTitle = 'Клиенты';
  static const String diagnosticCardTitle = 'Диагностика';
  static const String reportsCardTitle = 'Отчеты';
}

class ReportsScreenMessages {
  static const String newReportTitleText = 'Новый отчет';
  static const String newReportCardSelectText =
      'Выберите диагностическую карту';
  static const String popupMenuViewReportText = 'Просмотр';
  static const String popupMenuEditReportText = 'Редактирование';
  static const String popupMenuPrintReportText = 'Печать';
  static const String popupMenuDeleteReportText = 'Удаление';
  static const String popupMenuCardItemText = 'Диагностика';
  static const String popupMenuMainReportItemText = 'Основной';

  static const String reportHeaderDiagnosticText = 'Диагностика:';
  static const String reportHeaderDiagnosticDateText = 'Дата проведения:';
  static const String reportHeaderDiagnosticClientText = 'Клиент:';
  static const String reportHeaderReportTypeText = 'Отчет:';
  static const String diagnosticDefaultText = 'Выберите диагностику';
  static const String diagnosticDateDefaultText = 'Дата диагностики';
  static const String diagnosticClientNameDefaultText = 'Имя клиента';
  static const String reportTypeDefaultText = 'Выберите тип отчета';
  static const String reportTypeText = 'Основной';
  static const String reportDefaultTitleText = 'Новый отчет';
}

class ProfileScreenMessages {
  static const String noPhoneNumberText = 'Контактный телефон: Не указан';
  static const String phoneNumberTitleText = 'Контактный телефон:';
  static const String registerDateTitleText = 'Дата регистрации:';
  static const String userRoleLabelText = 'Статус:';
  static const String userRoleUserText = 'Пользователь';
  static const String userRoleAdminText = 'Администратор';
  static const String editProfileButtonText = 'Редактировать профиль';
  static const String convertProfileButtonText =
      'Зарегистрироваться\nи Сохранить данные';
  static const String signOutButtonText = 'Выход';
}

class SharedMessages {
  static const String diagnosticScreenTitle = 'Диагностика';
  static const String refbooksScreenTitle = 'Справочники';
  static const String clientsScreenTitle = 'Клиенты';
  static const String reportsScreenTitle = 'Отчеты';
  static const String profileScreenTitle = 'Профиль';
  static const String emptySnapshot = 'В данной категории нет документов';
  static const String anonymousUserTextLabel = 'Неизвестный';
  static const String backButtonText = 'Назад';
  static const String editInfoTextTitle = 'Изменение информации';
  static const String attentionLabelText = 'Внимание';
  static const String userRoleWarningText =
      'Данный функционал доступен только пользователям, имеющим статус: Администратор';
  static const String futuresInfoLabelText = 'Информация';
  static const String futuresInfoText =
      'В настоящее время данный функционал не реализован';
  static const String alertPrimaryButtonText = 'Ок';
  static const String alertSecondaryButtonText = 'Отмена';
}

class ErrorMessages {
  static const String emptyTextFieldError = 'Поле не может быть пустым';
  static const String minLengthTextFieldError =
      'Поле должно содержать не менее';
  static const String maxLengthTextFieldError =
      'Поле должно содержать не более';
  static const String errorWeakPassword = 'Пароль недостаточно надежен';
  static const String errorInvalidEmail =
      'Неверный формат адреса электронной почты';
  static const String errorEmailAlreadyInUse =
      'Электронная почта уже используется другой учетной записью';
  static const String errorWrongPassword = 'Неверный пароль';
  static const String errorUserNotFound =
      'Нет пользователя, соответствующего данному адресу электронной почты, или пользователь был удален';
  static const String errorUserDisabled = 'Пользователь временно заблокирован';
  static const String errorTooManyRequest = 'Превышен лимит на попытки входа';
  static const String errorOperationNotAllowed =
      'Данный способ входа временно недоступен';
  static const String newClientPhoneNumberErrorMessage =
      'Неправильный номер телефона';
  static const String refBookNotFoundText = 'Справочник не найден';
}
