
#Область СлужебныйПрограммныйИнтерфейс

/////////////////// ИНИЦИАЛИЗАЦИЯ ВНЕШНЕГО МЕНЕДЖЕРА /////////////////////////

// Метод инициализации менеджера внешнего оборудования
// Клиентское приложение обязано сразу после создания объекта-менеджера в своем
// контексте проинициализировать его посредством вызова данного метода и перечи в его параметрах
// ссылку на свой контекст, в котором реализованы методы обратного вызова
// (методы-обработчики событий из системы управления оборудованием)
// Приложение должно использовать только один экземпляр данного менеджера в течение всего
// сеанса своей работы и обязательно вызывать обратный метод Done перед завершением работы
//
// Входные параметры:
//   ApplicationRef      - ссылка на контекст клиентского приложения, с экспортннми
//                                   методами обработки событий (DataEventHandler, TaskStateHandler,
//                                   ErrorEventHandler, MessageDlgHandler) доступными для вызова менеджеру
// Возвратные параметры:
//   ResultCode          - число, если метод не выполнил свою задау и возвращает отрицательный результат,
//                         то в данном параметре возвращается код возникшей ошибки
//   ResultDescription   - строка, в которой возвращается текстовое описание ошибки
// Возвращает:
//   булево значение как результат своего исполнения
//   Если данный метод вернул Ложь, то в возвратных параметрах содержится информация об ошибке, а объект считается
//   не готовым к исполнению своих функций, подлежит выгрузке из памяти (очистке ссылки на него в контексте приложения)
Function Init(ApplicationRef, ResultCode = 0, ResultDescription = "") Export

	Result = False; // Пока мы еще ничего не сделали чтобы можно было сказать что уже достигнут положительный результат

	Попытка // Код вызвавшего нас приложения ни при каких условиях не должен трапаться

		// Временно, на этапе разработки и отладки можно включить режим вывода диагностических сообщений
		SetManagerProperty("IsDebugMode", True); // В режиме нормальной эксплуатации нужно ставить False

		// Массив текстовых строк сообщений
		ArrayOfMessages = FillArrayOfMessages();
		If Not SetManagerProperty("ArrayOfMessages", ArrayOfMessages, ResultCode , ResultDescription) Then
			Return False;
		EndIf;
		
		// Разрешенные типы в системе управления внешним оборудованием
		StrucOfTypes = FillStrucOfTypes();
		If Not SetManagerProperty("StrucOfTypes", StrucOfTypes, ResultCode , ResultDescription) Then
			Return False;
		EndIf;

		// Проверим не был ли уже передан нам каталог систсемы управления оборудованием 
		// Это можно сделать через установку свойства GetManagerProperty("ModelsFolder", Путь):
		// до вызова данного метода инициализации
		ModelsFolder = "";
		Если НЕ GetManagerProperty("ModelsFolder", ModelsFolder) OR TypeOf(ModelsFolder) <> Type("String") Тогда
			ModelsFolder = "";
		КонецЕсли;
		Если ПустаяСтрока(ModelsFolder) Тогда
			// Определим каталог установки системы управления внешним оборудованием самостоятельно
			Попытка
				WS = New COMObject("WScript.Shell");
				ModelsFolder = WS.RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\ProgramFilesDir");
			Исключение
				ResultCode = 11;
				ResultDescription = GetMessage(2, ОписаниеОшибки());
				Return False;
			КонецПопытки;
			// Проверка что получилось
			Если ПустаяСтрока(ModelsFolder) Тогда
				ModelsFolder = "C:\Program Files\Equipment\"; // если не определились то лучше так попробовать чем вообще никак
			ИначеЕсли (Прав(ModelsFolder,1) = "\") Тогда
				ModelsFolder = ModelsFolder + "Equipment\";
			Иначе
				ModelsFolder = ModelsFolder + "\Equipment\";
			КонецЕсли;
			SetManagerProperty("ModelsFolder", ModelsFolder);
		КонецЕсли;

		// Проверим существует ли файл описания установленных моделей
		ModelDescFileName = "";
		Если Not ExistModelsDescription(ModelDescFileName, ResultCode, ResultDescription) Тогда
			Return False;
		КонецЕсли;
		// Прочитаем основной файл системы (Models.xml) и узнаем путь к каталогу экземпляров
		StrucOfParam = Неопределено;
		Если Not ReadModelsDataFile(ModelDescFileName,"DevicesDataFolder", "", StrucOfParam, , ResultCode, ResultDescription) Тогда
			Return False;
		КонецЕсли;
		// Вот он наш каталог экземпляров
		DevicesFolder = "";
		StrucOfParam.Property("DevicesDataFolder", DevicesFolder);

		// Проверим его на корректность
		Если НЕ ЗначениеЗаполнено(DevicesFolder) Тогда
			ResultCode = 14;
			ResultDescription = GetMessage(19) + Символы.ПС + ModelDescFileName;
			Return False;
		ИначеЕсли (Прав(DevicesFolder,1)<>"\") Тогда
			DevicesFolder = DevicesFolder + "\";
		КонецЕсли;

		// Проверим наличие каталога и прав на запись в него
		If Not IsPathWriteAble(DevicesFolder, ResultCode, ResultDescription) Then
			Return False;
		EndIf;

		// Запомним проверенное значение каталога экземпляров устройств
		SetManagerProperty("DevicesFolder", DevicesFolder);

		// Версия менеджера
		SetManagerProperty("SystemMajorVersion", GetSystemMajorVersion());
		SetManagerProperty("SystemMinorVersion", GetSystemMinorVersion());

		// Инициализация компоненты обеспечения сетевого транспорта должна быть здесь
		// ...Проверка наличия файла внешней библиотеки
		// ...проверка создания объекта
		// ...инициализация объекта и проверка его состояния

		SetManagerProperty("IsNetworkMode", False);                    // Сеть еще не включали
		SetManagerProperty("IsServerMode", False);                     // Серверный режим тем более тоже нет
		#If NOT WebClient Then
		SetManagerProperty("ComputerName", ВРег(ИмяКомпьютера()));     // Имя текущей рабочей станции
		#EndIf
		SetManagerProperty("SessionID", GUIDtoID(String(New UUID)));   // Уникальный идентификатор текущей сессии
		SetManagerProperty("ServerPort", "");                          // Номер порта сервера пока не задан
		SetManagerProperty("Application", ApplicationRef);             // Внимание! Эту ссылку необходимо очищать в Done
		// Установим признак полной инициализации менеджера, (вот так "хитро" потому что через SetManagerProperty нельзя)
		глПодключаемоеОборудование.ПараметрыДрайверМенеджера.Вставить("IsInitialized", True);

		// Вот теперь только достигнут положительный результат
		Result = True;

	Исключение
		ResultCode = 7;
		ResultDescription = GetMessage(20) + ОписаниеОшибки();
	КонецПопытки;

	// Возвращаем результат работы метода
	Return Result;

EndFunction

// Метод установки обработчика событий DataEvent
Function SetDataEventHandler(HandlerName = "") Export;

	Если ТипЗнч(HandlerName) = Тип("Строка") Тогда
		глПодключаемоеОборудование.ПараметрыДрайверМенеджера.Вставить("DataEventHandler", HandlerName);
		Return True;
	Иначе
		Return False;
	КонецЕсли;

EndFunction

// Метод установки обработчика событий TaskState
Function SetTaskStateHandler(HandlerName = "") Export;

	Если ТипЗнч(HandlerName) = Тип("Строка") Тогда
		глПодключаемоеОборудование.ПараметрыДрайверМенеджера.Вставить("TaskStateHandler", HandlerName);
		Return True;
	Иначе
		Return False;
	КонецЕсли;

EndFunction

// Метод установки обработчика событий ErrorEvent
Function SetErrorEventHandler(HandlerName = "") Export;

	Если ТипЗнч(HandlerName) = Тип("Строка") Тогда
		глПодключаемоеОборудование.ПараметрыДрайверМенеджера.Вставить("ErrorEventHandler", HandlerName);
		Return True;
	Иначе
		Return False;
	КонецЕсли;

EndFunction

// Метод установки обработчика событий MessageDlg
Function SetMessageDlgHandler(HandlerName = "") Export;

	Если ТипЗнч(HandlerName) = Тип("Строка") Тогда
		глПодключаемоеОборудование.ПараметрыДрайверМенеджера.Вставить("MessageDlgHandler", HandlerName);
		Return True;
	Иначе
		Return False;
	КонецЕсли;

EndFunction

// Метод деинициализации менеджера внешнего оборудования
// клинтскому приложению необходимо вызывать данный метод перед очисткой ссылки на объект менеджера
// или перед завершением своей работы во избежание проблем с неочищенными перекрестными ссылками
Function Done() Export;

	Попытка
		// Выгрузка из памяти объектов обработчиков, очистка структур и переменных-ссылок на объекты
		DevicesStructure = Undefined;
		Если GetManagerProperty("DevicesStructure", DevicesStructure) Then
			// Обойдем все устройства по-очереди и поотключаем их
			Для каждого StrucElement Из DevicesStructure Цикл
				DeviceParameters = StrucElement.Value;
				Если DeviceParameters.DriverObject = Undefined Тогда
					// Обработчик уже выгружен и нам тут ничего делать не нужно
				Иначе
					// Проверим текущее состояние оборудования
					Если DeviceParameters.StatusCode <> 0 Тогда
						// Если все делать правильно, то устройство сначала нужно выключить
						InParam = Undefined;
						OutParam = Undefined;
						TimeOut = 1;
						Попытка
							DeviceParameters.DriverObject.Disable(InParam, OutParam, TimeOut);
						Исключение
							WriteLog("Done", "Disable", "Ошибка выключения {" + DeviceParameters.DeviceID + "} - " + ОписаниеОшибки());
						КонецПопытки;
					КонецЕсли;
					Попытка // вызова деструктор самого обаботчика
						DeviceParameters.DriverObject.Close(); // пусть очистит у себя ссылку на нас и другие структуры
					Исключение
						WriteLog("Done","Close","Модель " + DeviceParameters.ModelID + " ошибка вызова Close - " + ОписаниеОшибки());
					КонецПопытки;
					// Теперь почистим все наши ссылки на этот объект
					DeviceParameters.DriverObject = Undefined;
				КонецЕсли;
			КонецЦикла;
			DevicesStructure.Clear();
		КонецЕсли;
	Исключение
	КонецПопытки;

	// Теперь выполним самое главное
	SetManagerProperty("Application", Undefined); // Это важно! Необходимо очистить эту перекрестную ссылку!
	SetManagerProperty("IsInitialized", False);   // Сбросим признак того что менеджер инициализирован

	Return True; // Если вернем Ложь приложение все равно никак не сможет специально отработать

EndFunction

// -------------------------------------------------------------------------------------------------
// - ЭКСПОРТНЫЕ МЕТОДЫ МЕНЕДЖЕРА  интерфейс предоставляемый клиентскому приложению (конфигурации) -
// -------------------------------------------------------------------------------------------------

// Метод предназначен для получения значения свойства менеджера по его имени
// Входные параметры:	
//   PropertyName        - строка, идентификатор свойства
// Возвратные параметры:
//   PropertyValue       - значение искомого свойства
//   ResultCode          - число, если метод не выполнил свою задау и возвращает отрицательный результат,
//                         то в данном параметре возвращается код возникшей ошибки
//   ResultDescription   - строка, в которой возвращается текстовое описание ошибки
// Возвращает: значение типа булево, True при успешном выполнении, False в противном случае
Function GetManagerProperty(PropertyName, PropertyValue, ResultCode = 0, ResultDescription = "") Export;

	Result = False;

	Try
		If PropertyName = "DevicesStructure" Then
			// Примечание для разработчиков: следует понимать что при реализации менеджера в виде компоненты
			// в ней безусловно будет где хранить свои переменные и служебные структуры данных, а для эмуляции
			// отдельного контекста в данном примере 1С-реализации все это хранится в отдельной якобы "закрытой"
			// структуре данных в глобальном контексте. Суть в том чтобы в эти структуры никто не обращался за
			// исключением методов самого менеджера (то есть процедур и функций данного модуля) Спасибо за внимание
			Result = глПодключаемоеОборудование.Свойство("ТаблицаУстройствДМ", PropertyValue);
		Else
			Result = глПодключаемоеОборудование.ПараметрыДрайверМенеджера.Свойство(PropertyName, PropertyValue);
		EndIf;
		If Not Result Then
			ResultCode = 6;
			ResultDescription = NStr("ru='Не найдено запрошенное свойство ""%PropertyName%""'");
		EndIf;
	Except
		ResultCode = 5;
		ResultDescription = NStr("ru='Исключение при получения свойства менеджера ""%PropertyName%""'");
		ResultDescription = ResultDescription +Символы.ПС + GetMessage(2) + ОписаниеОшибки();
	EndTry;

	ResultDescription = StrReplace(ResultDescription, "%PropertyName%", PropertyName);
	Return Result;

EndFunction

// Метод предназначен для устновки значения свойства менеджера по его имени
// Входные параметры:
//   PropertyName        - строка, идентификатор свойства
//   PropertyValue       - новое значение свойства
// Возвратные параметры:
//   ResultCode          - число, если метод не выполнил свою задау и возвращает отрицательный результат,
//                         то в данном параметре возвращается код возникшей ошибки
//   ResultDescription   - строка, в которой возвращается текстовое описание ошибки
// Возвращает: значение типа булево, True при успешном выполнении, False в противном случае
Function SetManagerProperty(PropertyName, PropertyValue, ResultCode = 0, ResultDescription = "") Export;

	// Проверим какое свойство хотят установить снаружи
	UppedPropertyName = Upper(PropertyName);
	// Внутренние служебные свойства менять нельзя
	RestrictedProps = ",IsInitialized,IsNetworkMode,IsServerMode,SystemMajorVersion,SystemMinorVersion";
	If Find(Upper(RestrictedProps), UppedPropertyName) > 0 Then
		// Вот как раз и нельзя
		ResultCode = 3;
		ResultDescription = НСтр("ru='Свойство менеджера ""%PropertyName%"" не доступно для изменения'");
		ResultDescription = StrReplace(ResultDescription, "%PropertyName%", PropertyName);
		Return False;
	EndIf;

	// Проверим инициализирован ли уже объект менеджера
	IsInitialized = False;
	If Not GetManagerProperty("IsInitialized", IsInitialized) Then
		IsInitialized = False;
	EndIf;

	// А значения нижеперечисленных свойств можно устанавливать только до инициализации менеджера
	RestrictedProps = ",ModelsFolder,DevicesFolder,";
	If IsInitialized AND Find(Upper(RestrictedProps), UppedPropertyName) > 0 Then
		ResultCode = 4;
		ResultDescription = GetMessage(21);
		Return False;
	EndIf;

	Try // Установим новое значение свойства
		глПодключаемоеОборудование.ПараметрыДрайверМенеджера.Вставить(PropertyName, PropertyValue);
		Result = True;
	Except
		ResultCode = 2;
		ResultDescription = GetMessage(22, ОписаниеОшибки());
		Result = False;
	EndTry;

	ResultDescription = StrReplace(ResultDescription, "%PropertyName%", PropertyName);
	Return Result;

EndFunction

// Метод предназначен для передачи исполнения команды устройству в синхронном режиме
// Возврат управления в вызвавший данный метод код произойдет только после завершения исполнения команды устройством
// Входные параметры:
//   DeviceID           - строка, идентификатор устройства (GUID в виде строки)
//   CommandName        - строка, имя команды оборудования (реглементированно согласно типу оборудования)
//   InputParameters    - SafeArray содержащий параметры команды, либо НЕОПРЕДЕЛЕНО если непредусмотрены
//   TimeOut            - число, устанавливаемый интервал времени ожидания результатов исполнения команды, 
//                                        если передается 0, то используется значение по умолчанию (из настроек устройства)
// Возвратные параметры:
//   ResultCode         - число, если команда не выполнилась (произошла ошибка), то в данном параметре 
//                        возвращается код ошибки (регламентируется на уровне типа оборудования)
//   ResultDescription  - строка, если команда не выполнилась (произошла ошибка), то в данном параметре 
//                        возвращается текстовое описание ошибки
//   ResultData         - SafeArray  (только в случае успешного исполнения команды) содержит данные с 
//                        результатами исполнения команды, либо НЕОПРЕДЕЛЕНО (не предусмотрены в команде)
//                        (см. описание команды согласно конкретному типу оборудования)
// Служебные параметры: (не используются при вызове из клиентского приложения)
//   CommandID          - строка, идентификатор сетевой команды к оборудованию от удаленного менеджера,
//                        либо пустая строка если вызов произошел от локального клиентского приложения
// Возвращает:             значение типа булево True при успешном выполнении, False в противном случае
Function ExecuteCommand(Val DeviceID,
                        Val CommandName,
                        InputParameters = Undefined,
                        TimeOut = 0,
                        ResultCode = 0,
                        ResultDescription = "",
                        ResultData = Undefined,
                        CommandID = "") Export

  Попытка // Код вызвавшего нас приложения ни при каких условиях не должен трапаться

	// Основные рабочие методы менеджера можно вызывать только после его успешной инциализации
	Если НЕ IsInitialized(ResultCode, ResultDescription) Тогда
		ResultData = New COMSafeArray("VT_VARIANT", 2);
		ResultData.SetValue(0, ResultCode);
		ResultData.SetValue(1, ResultDescription);

		Return False; // Код ошибки и ее описание для возврата в вызвавший нас код уже заполнены
	КонецЕсли;

	// Сначала проверки входных параметров на корректность, идентификатор устройства
	Если НЕ CheckID(DeviceID, ResultCode, ResultDescription) Тогда
		ResultData = New COMSafeArray("VT_VARIANT", 2);
		ResultData.SetValue(0, ResultCode);
		ResultData.SetValue(1, ResultDescription);

		Return False; // Код ошибки и описание уже заполнены функцией "CheckID"
	КонецЕсли;

	// Сначала проверки входных параметров на корректность, имя команды
	Если НЕ CheckCommand(CommandName, ResultCode, ResultDescription) Тогда
		ResultData = New COMSafeArray("VT_VARIANT", 2);
		ResultData.SetValue(0, ResultCode);
		ResultData.SetValue(1, ResultDescription);

		Return False; // Код ошибки и описание уже заполнены функцией "CheckCommand"
	КонецЕсли;

	// Получим параметры устройства (либо из кеша, либо будет создан новый экземпляр)
	DeviceParameters = Неопределено;
	Если НЕ GetDeviceParameters(DeviceID, DeviceParameters, ResultCode, ResultDescription) Тогда
		ResultData = New COMSafeArray("VT_VARIANT", 2);
		ResultData.SetValue(0, ResultCode);
		ResultData.SetValue(1, ResultDescription);

		Return False; // Код ошибки и описание уже заполнены функцией "GetDeviceParameters"
	КонецЕсли;

	// При работе с удаленным устройством (по сети) вызовы перенаправляются в менеджер сетевого взаимодействия
	Если DeviceParameters.IsNetworkDevice Тогда
		Если IsNetworkMode() Тогда
		// ! Раскомментировать когда будет реазлизована работа с удаленными устройствами
		//	// Передача вызова в менеджер сетевого взаимодействия
		//	 Result = ExecuteRemoteCommand(DeviceParameters, CommandName, InputParameters, TimeOut, ResultCode, ResultDescription, ResultData);
		// Иначе
			ResultCode = 81; // Сетевой режим работы не поддерживается
			ResultDescription = GetMessage(81);

			ResultData = New COMSafeArray("VT_VARIANT", 2);
			ResultData.SetValue(0, ResultCode);
			ResultData.SetValue(1, ResultDescription);

			Return False;
		КонецЕсли;
	КонецЕсли;

	// Запомним исходное состояние (на момент до начала обработки команды)
	ИсходноеСостояниеКод = DeviceParameters.StatusCode;
	ИсходноеСостояниеИмя = DeviceParameters.StatusName; // Использование возможно для целей отладки и визуализации
	СписокОбщихКоманд = "|GETDEVICEINFO|CHECKHEALTH|GETSETTINGS|SETSETTINGS|SHOWSETTINGSDLG|ENABLE|DISABLE|";

	// Проверим готовность устройства к выполнению команды
	Если (ИсходноеСостояниеКод = 2) Тогда // ЗАНЯТО в данный момент уже выполняется команда (невозможно при 1С-реализации)
		// Обработчики устройств не реентерабельны (только одна команда в один момент времени может выполняться обработчиком)
		ResultCode = 71;
		ResultDescription = GetMessage(71);
		ResultDescription = StrReplace(ResultDescription, "%CommandName%", DeviceParameters.CommandName);
		Return False;
	ИначеЕсли (ИсходноеСостояниеКод = 3) И DeviceParameters.ExclusiveOwner И (DeviceParameters.OwnerID <> GetSessionID()) Тогда
		// ЗАБЛОКИРОВАНО под монопольное использование другой рабочей сессией (не данной)
		ResultCode = 72;
		ResultDescription = GetMessage(72);
		ResultDescription = StrReplace(ResultDescription, "%OwnerName%", DeviceParameters.OwnerName);
		Return False;
	ИначеЕсли (CommandName = "ENABLE") И (ИсходноеСостояниеКод = 1) Тогда
		// Уже включенное оборудование нет смысла включать еще раз, поэтому сэкономим тут в смысле ничего делать не будем
		ResultCode = 0;
		ResultDescription = GetMessage(0); // Устройство уже включено - ничего делать не станем
		Return True;
	ИначеЕсли Найти(СписокОбщихКоманд, "|" + CommandName + "|") > 0 Тогда
		// Любую из "общих команд" можно пропускать на еще не включенное оборудование
	ИначеЕсли (ИсходноеСостояниеКод = 0) Тогда
		// Перед использованием оборудования его предварительно требуется привести в состояние готовности комадой Enable
		ResultCode = 70;
		ResultDescription = GetMessage(70);
		Return False;
	КонецЕсли;
	
	// Проверим доступность и готовность обработчика, получим его объект
	Если DeviceParameters.DriverObject <> Undefined Тогда
		// Объект драйвера обработчика устройства уже создан, хорошо
	ИначеЕсли НЕ CreateDriverObject(DeviceParameters, ResultCode, ResultDescription) Тогда
		// Не получилось создать и проинициализировать объект драйвера обработчика устройства
		Return False; // Код ошибки и описание уже заполнены функцией "CreateDriverObject"
	КонецЕсли;
	
	// Имеем готовый объект обработчика устройства - передадим ему команду на исполнение
	DeviceParameters.StatusCode = 2;
	DeviceParameters.StatusName = "Занято..."; // только для визуализации
	DeviceParameters.CommandName = CommandName;
	ResultData = Неопределено; // Сюда обработчик поместит контейнер с данными результата, либо код и описание ошибки
	Result = Неопределено;     // Результата у нас еще нет на этот момент
	
	// Запомним данные сетевой команды (если команда была передана нам по сети от удаленного менежера управления оборудованием)
	Если НЕ ПустаяСтрока(CommandID) Тогда
		Если НЕ DeviceParameters.IsNowConnected Тогда
			DeviceParameters.IsNowConnected = Истина; // Это вторая и последняя точка установки этого свойства в ИСТИНА
		КонецЕсли;                                    // (первая где мы выступаем в роди клиента и устанавливаем соединение)
		// Запрос на исполнение данной команды к нам пришел по сети
		Если ПустаяСтрока(DeviceParameters.CommandID) Тогда
			// Ставим ID текущей команды только если устройство не было уже захвачено ранее командой Claim
			DeviceParameters.CommandID = CommandID; // запомним идентификатор команды чтобы обратные вызовы и события
			                                        // шли в рамках того же самого соединения (от команды Claim)
		Иначе
			// иначе должен остаться текущий идентификатор (от первоначальной команды Claim)
		КонецЕсли;
	КонецЕсли;
	
	Попытка // Попытаемся вызвать заказанную команду-метрод обработчика

		СтрокаВыражения = "Result = DeviceParameters.DriverObject." + CommandName + "(InputParameters, ResultData, TimeOut);";

		Выполнить(СтрокаВыражения); // Попытка нам нужна именно для этого оператора
		
		Если ТипЗнч(Result) <> Тип("Boolean") Тогда
			// Некорркетная реализация интерфейса - методы обработчика должны возвращать булево значение
			Result = False;
			ResultCode = 76;
			ResultDescription = GetMessage(76);
			ResultDescription = StrReplace(ResultDescription, "%CommandName%", CommandName);
			ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceID);
		ИначеЕсли Result Тогда
			// команда была выполнена успешно
			ResultCode = 0;
			ResultDescription = GetMessage(0);
		Иначе 
			// Произошла ошибка при исполнении команды, в параметре ResultData должны быть код и описание
			Попытка // попытаемся получить их
				ResultCode = ResultData.GetValue(0);
				ResultDescription = ResultData.GetValue(1);
			Исключение
				// Не заполнен стандартный массив с описанием ошибки - это некорректная реализация обработчика
				ResultCode = 78;
				ResultDescription = GetMessage(78);
				ResultDescription = StrReplace(ResultDescription, "%CommandName%", CommandName);
				ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceID);
			КонецПопытки;
		КонецЕсли;

	Исключение
		// Неверная команда оборудования (нет такой у типа), либо некорректная реализация обработчика (нет вызванного метода)
		ResultCode = 77;
		ResultDescription = GetMessage(77) + Символы.ПС + GetMessage(2, ОписаниеОшибки());
		ResultDescription = StrReplace(ResultDescription, "%CommandName%", CommandName);
		ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceID);
		ResultDescription = StrReplace(ResultDescription, "%TypeName%", DeviceParameters.TypeName);
		Result = False;
	КонецПопытки;

	// Возвращаем исходное состояние устройства
	DeviceParameters.StatusCode = ИсходноеСостояниеКод;
	DeviceParameters.StatusName = ИсходноеСостояниеИмя; // только для визуализации
	DeviceParameters.CommandName = "";
	// Вернем в исходное состояние сетевые реквизиты удаленной команды
	Если НЕ ПустаяСтрока(CommandID) Тогда
		// Запрос на исполнение данной команды к нам пришел по сети
		Если (DeviceParameters.CommandID = CommandID) Тогда // Если устройство было Claimed то идентификаторы не совпадут
			                                                // и останется какой был (от Claim)
			DeviceParameters.CommandID = ""; // очистим идентификатор текущей команды
		КонецЕсли;
	КонецЕсли;

	// Некоторые команды требуют дополнительной обработки со стороны менеджера
	Если (CommandName = "ENABLE") И Result Тогда
		// Изменим состояние устройства на "Включено"
		DeviceParameters.StatusCode = 1;
		DeviceParameters.StatusName = "Включено";  // только для визуализации
		
	ИначеЕсли (CommandName = "DISABLE") Тогда
		// Нужно выгрузить обработчик из памяти
		Попытка // Вызвали деструктор самого обаботчика
			DeviceParameters.DriverObject.Close(); // пусть очистит у себя ссылку на нас и другие структуры
		Исключение
		КонецПопытки;
		// Теперь почистим все наши ссылки на этот объект
		DeviceParameters.DriverObject = Undefined;
		DeviceParameters.StatusCode = 0;
		DeviceParameters.StatusName = "Выключено"; // только для визуализации

	ИначеЕсли Result И НЕ DeviceParameters.IsNetworkDevice И
	         ((CommandName = "SETSETTINGS") ИЛИ (CommandName = "SHOWSETTINGSDLG")) Тогда
		// Была команда установки новых настроек и обработчик успешно принял новые настройки тогда
		// если это наше локальное оборудование, то требуется их сразу сохранить в хранилище настроек
		Попытка
			// Но сначала получим их обратно из обработчика (там могла произойти их внутренняя валидация)
			OutParameters = Неопределено;
			Если DeviceParameters.DriverObject.GetSettings(Неопределено, OutParameters, 0) Тогда
				Settings = OutParameters.GetValue(0); // Получили массив настроек
				Если НЕ SaveDeviceSettings(DeviceParameters, Settings, ResultCode, ResultDescription) Тогда
					// Ошибка при попытке сохранить настройки оборудования во внешнем хранилище настроек
					Result = False;
					ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceID);
					WriteLog("ExecuteCommand", "ErrorMessage", ResultDescription, "Error");
				КонецЕсли;
			КонецЕсли;
		Исключение
			// Ошибка при попытке сохранить настройки оборудования во внешнем хранилище настроек
			Result = False;
			ResultCode = 50;
			ResultDescription = GetMessage(50) + ОписаниеОшибки();
			ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceID);
			WriteLog("ExecuteCommand", "ErrorMessage", ResultDescription, "Error");
		КонецПопытки;
	КонецЕсли;

  Исключение
	// Непредусмотренная исключительная ситуация, перехватили чтобы "не свалися" код вызвавшего нас приложения
	Result = False;
	ResultCode = 79;
	ResultDescription = GetMessage(79) + GetMessage(2, ОписаниеОшибки());
	WriteLog("ExecuteCommand",
	         CommandName,
	         "DeviceID = {" + DeviceID + "} - " + ResultDescription,
	         "Error");
  КонецПопытки;

  // Возвращаем признак успешности исполнения метода
  Return Result;

EndFunction

// Метод используется клиентским приложением для получения списка установленных моделей внешнего оборудования
// Входные параметры:	
//   ConnectStr          - (необязательный) строка, содержащая параметры подключения к удаленной станции
//                         содержит сетевое имя (либо адрес) рабочей станции и порт сервера на котором
//                         ожидаются входящие соединяния-запросы на исполнение команд от других станций
//                         имя и порт серверной станции разделяются двоеточием
//                         Примеры содержимого данного параметра: "SERVERNAME:1500" "10.2.1.5:1500"
// Возвратные параметры:
//   ModelsArray         - SafeArray содержащий данные всех установленных моделей на рабочей станции (компьютере)
//   ResultCode          - число, код возникшей ошибки
//   ResultDescription   - строка, если команда не выполнилась (произошла ошибка), то в данном параметре возвращается
//                         текстовое описание ошибки
// Возвращает: значение типа булево True при успешном выполнении, False в противном случае
Function GetModelsList(ModelsArray, ResultCode = 0, ResultDescription = "", ConnectStr = "") Export

	// Основные рабочие методы менеджера можно вызывать только после его успешной инциализации
	Если НЕ IsInitialized(ResultCode, ResultDescription) Тогда
		Return False; // Код ошибки и ее описание для возврата в вызвавший нас код уже заполнены
	КонецЕсли;

	Result = False; // Пока еще ничего не сделано чтобы можно было сказать что уже достигнут положительный результат

	Попытка // Код вызвавшего нас приложения ни при каких условиях не должен трапаться

		ModelsList = Неопределено;
		// Считаем данные всех моделей
		Если Not ReadModelsDataFile( , "", "*", , ModelsList, ResultCode, ResultDescription) Тогда
			Return False; // Код ошибки и ее описание для возврата в вызвавший нас код уже заполнены
		КонецЕсли;

		// Перепакуем данные в SafeArray
		ВсегоМоделей = ModelsList.Количество();
		ModelsArray = CreateArray(ВсегоМоделей, 12);
		Для Индекс = 0 По ВсегоМоделей - 1 Цикл
			ModelsArray.SetValue(Индекс, 0, ModelsList[Индекс].ModelName);
			ModelsArray.SetValue(Индекс, 1, ModelsList[Индекс].TypeName);
			ModelsArray.SetValue(Индекс, 2, ModelsList[Индекс].ProcessorName);
			ModelsArray.SetValue(Индекс, 3, ModelsList[Индекс].ProcessorType);
			ModelsArray.SetValue(Индекс, 4, ModelsList[Индекс].MajorVersion);
			ModelsArray.SetValue(Индекс, 5, ModelsList[Индекс].MinorVersion);
			ModelsArray.SetValue(Индекс, 6, ModelsList[Индекс].BuildVersion);
			ModelsArray.SetValue(Индекс, 7, ModelsList[Индекс].Developer);
			ModelsArray.SetValue(Индекс, 8, ModelsList[Индекс].ContactInfo);
			ModelsArray.SetValue(Индекс, 9, ModelsList[Индекс].ExternalEventHook);
			ModelsArray.SetValue(Индекс, 10, ModelsList[Индекс].ModelID);
			ModelsArray.SetValue(Индекс, 11, ModelsList[Индекс].Description);
		КонецЦикла;

		// Вот теперь достигнут положительный результат
		Result = True;

	Исключение
		Result = False;
		ResultCode = 1;
		ResultDescription = "внутрення ошибка в коде GetModelsList - " + ОписаниеОшибки();
		WriteLog("GetModelsList", "Exception", ResultDescription, "Error");
	КонецПопытки;

	Return Result;;

EndFunction

// Метод используется клиентским приложением для получения списка настроенного внешнего оборудования 
// Входные параметры:
//   ConnectStr          - (необязательный) строка, содержащая параметры подключения к удаленной станции
//                         содержит сетевое имя (либо адрес) рабочей станции и порт сервера на котором
//                         ожидаются входящие соединяния-запросы на исполнение команд от других станций
//                         имя и порт серверной станции разделяются двоеточием
//                         Примеры содержимого данного параметра: "SERVERNAME:1500" "10.2.1.5:1500"
// Возвратные параметры:
//   DevicesList         - SafeArray содержащий данные всех устройств, определенных во внешнем хранилище настроек
//   ResultCode          - число, если метод не выполнил свою задау и возвращает отрицательный результат,
//                         то в данном параметре возвращается код возникшей ошибки
//   ResultDescription   - строка, в которой возвращается текстовое описание ошибки
// Возвращает: результат типа булево, True при успешном выполнении, False в противном случае
Function GetDevicesList(DevicesList, ResultCode = 0, ResultDescription = "", ConnectStr = "") Export

	Result = False; // На данный момент список устройств еще не составлен

	// Основные рабочие методы менеджера можно вызывать только после его успешной инциализации
	Если НЕ IsInitialized(ResultCode, ResultDescription) Тогда
		Return False; // Код ошибки и ее описание для возврата в вызвавший нас код уже заполнены
	КонецЕсли;

	#If WebClient Then

	ResultCode = 99;
	ResultDescription = GetMessage(99);
	Return False;

	#Else

	// Считаем данные всех моделей, эти данные нам понадобяться при разборе данных каждого устройства
	ModelsArray = Неопределено;
	Если Not ReadModelsDataFile( , "", "*", , ModelsArray, ResultCode, ResultDescription) Тогда
		Return False;
	КонецЕсли;

	Попытка // Разбирать будем в попытке чтобы вызвавший нас код не уронить
		DevcesArray = New Array;
		DevicesFolder = "";
		GetManagerProperty("DevicesFolder", DevicesFolder);
		FilesArray = FindFiles(DevicesFolder, "*", False);
		Для Каждого Catalog Из FilesArray Цикл
			Если НЕ Catalog.IsDirectory() Тогда
				Продолжить;
			КонецЕсли;
			DeviceID = Catalog.BaseName;
			Если НЕ CheckID(DeviceID, ResultCode, ResultDescription) Тогда
				Продолжить; // Имя подкаталога не соответствует GUID'у - игнорирум этот подкаталог
			КонецЕсли;
			// Создадим структуру параметров устройства и заполним ее данными из внешнего хранилища настроек
			DeviceParameters = CreateDeviceParameters();
			DeviceParameters.DeviceID = DeviceID;
			DeviceParameters.Insert("ModelName", "");
			// Необходимо найти во внешнем хранилище базовую информацию по устройству (узнаем идентификатор модели)
			Если НЕ ReadDeviceParameters(DeviceID, DeviceParameters, ResultCode, ResultDescription) Тогда
				Продолжить; // Некорректное устройство не будем включать в список устройств, пропускаем
			КонецЕсли;
			// Найдем в ранее полученном списке модель устройства
			FindedModel = Undefined;
			Для Каждого Model Из ModelsArray Цикл
				Если Model.ModelID = DeviceParameters.ModelID Тогда
					FindedModel = Model;
					Прервать; // Нашли модель устройства
				КонецЕсли;
			КонецЦикла;
			Если FindedModel = Undefined Тогда
				// Не нашли модель устройства (модель удалили?) - тоже пропускаем такое оборудование
				Продолжить;
			Иначе
				// Добавим данные модели найденного устройства в его структуру параметров
				DeviceParameters.ModelName = FindedModel.ModelName;
				DeviceParameters.TypeName = FindedModel.TypeName;
				DeviceParameters.ProcessorName = FindedModel.ProcessorName;
				DeviceParameters.ProcessorType = FindedModel.ProcessorType;
				DeviceParameters.ExternalEventHook = FindedModel.ExternalEventHook;
			КонецЕсли;
			DevcesArray.Add(DeviceParameters);
		КонецЦикла;

		DevicesCount = DevcesArray.Count();
		Если DevicesCount > 0 Тогда
			// Нужно упаковать полученный список SafeArray для возврата в вызвавший код
			DevicesList = CreateArray(DevicesCount, 5);
			Для Индекс = 0 По DevicesCount - 1 Цикл
				DevicesList.SetValue(Индекс, 0, DevcesArray[Индекс].DeviceID);
				DevicesList.SetValue(Индекс, 1, DevcesArray[Индекс].DeviceName);
				DevicesList.SetValue(Индекс, 2, DevcesArray[Индекс].ModelID);
				DevicesList.SetValue(Индекс, 3, DevcesArray[Индекс].ModelName);
				DevicesList.SetValue(Индекс, 4, DevcesArray[Индекс].TypeName);
			КонецЦикла;

			// Вот теперь достигнут положительный результат
			Result = True;
		Иначе
			ResultCode = 52; // Не найдено ни одного устройства
			ResultDescription = GetMessage(52);
			Result = False;
		КонецЕсли;

	Исключение
		ResultCode = 51; // Внутренняя непредусмотренная ошибка
		ResultDescription = GetMessage(51, ОписаниеОшибки());
		Result = False;
	КонецПопытки;

	#EndIf

	Return Result;

EndFunction

// Метод предназначен для получения настроек по умолчанию для заданной модели оборудования
// Входные параметры:
//   ModelID           - строка, уникальный идентификатор модели оборудования настройки по умолчанию
//                       которой необходимо получить (будут вовзращены в параметре Settings см. ниже)
//   ConnectStr        - (необязательный) строка, содержащая параметры подключения к удаленной станции
//                       содержит сетевое имя (либо адрес) рабочей станции и порт сервера на котором
//                       ожидаются входящие соединяния-запросы на исполнение команд от других станций
//                       Имя и порт серверной станции разделяются двоеточием
//                       Примеры содержимого данного параметра: "SERVERNAME:1500" "10.2.1.5:1500"
// Возвратные параметры:
//   Settings          - SafeArray, первое измерение это строки массива, равно числу настроек в данной модели
// ..............................второе измерение массива это колонки (для набора настроек их ровно семь)
//                               идентификатор пятой настройки получается через .GetValue(4, 0);
//   ResultCode        - число   если команда не выполнилась (произошла ошибка), то в данном параметре
//                               возвращается код ошибки (регламентируется на уровне типа оборудования)
//   ResultDescription - строка, если команда не выполнилась (произошла ошибка), то в данном параметре
//                               возвращается текстовое описание ошибки
// Служебные параметры: (не используются при вызове из клиентского приложения)
//   DeviceParameters  - структура с данными обордуования, необязательный, если передан позволяет избежать
//                       повторного обращения в хранилище настроек
// Возвращает: значение типа булево , True при успешном выполнении, False в противном случае
Function GetDefaultSettings(ModelID, Settings, ResultCode = 0, ResultDescription = "", ConnectStr = "", DeviceParameters = Undefined) Export;

	Result = False; // На данный момент положительный результат еще не достигнут

	// Основные рабочие методы менеджера можно вызывать только после его успешной инциализации
	Если НЕ IsInitialized(ResultCode, ResultDescription) Тогда
		Return False; // Код ошибки и ее описание для возврата в вызвавший нас код уже заполнены
	КонецЕсли;

	// Сначала проверки входных параметров на корректность, идентификатор модели
	Если НЕ CheckID(ModelID, ResultCode, ResultDescription) Тогда
		Return False; // Код ошибки и ее описание для возврата в вызвавший нас код уже заполнены
	КонецЕсли;

	#If WebClient Then

	ResultCode = 99;
	ResultDescription = GetMessage(99);
	Return False;

	#Else

	Если DeviceParameters = Undefined Тогда
		NeedClearObjects = True;
		DeviceParameters = CreateDeviceParameters();
		// Необходимо найти во внешнем хранилище информацию о свойствах модели
		// Остальные данные из описания моделей, считаем только одну интересующую нас сейчас модель
		Models = Неопределено;
		Если Not ReadModelsDataFile( , , ModelID, , Models, ResultCode, ResultDescription) Тогда
			Return False; // ResultCode, ResultDescription уже заполнены
		КонецЕсли;
		ModelInfo = Models[0];
		// Используем полученные данные
		DeviceParameters.ModelID = ModelID;
		DeviceParameters.ProcessorName = ModelInfo.ProcessorName;
		DeviceParameters.ProcessorType = ModelInfo.ProcessorType;
		DeviceParameters.ExternalEventHook = ModelInfo.ExternalEventHook;

		// Сооздадим объект-абстракт не связанный еще ни с каким конкретным устройством
		Если НЕ CreateDriverObject(DeviceParameters, ResultCode, ResultDescription, True) Тогда
			Return False; // Код ошибки и описание уже заполнены функцией "ПолучитьОбъектОбработчика"
		КонецЕсли;
	Иначе
		// Если набор параметров уже был нам передан кодом, который нас вызвал, то он и будет заниматься очисткой ненужного
		NeedClearObjects = False;
	КонецЕсли;

	// Если у объекта-абстрака вызвать GetSettings то получим настройки по умолчанию
	// Подготовим параметры вызова
	InputParameters = Undefined; // Входных параметров у метода нет
	ResultData = Undefined;      // Вот сюда получим результат работы метода
	TimeOut = 0;                 // Этотпараметр будет проигнорирован
	Result = False;              // Заведем переменную для хранения финального резулььтата работы всего метода
	Попытка // Вызываем метод в обработчике
		СтрокаВыражения = "Result = DeviceParameters.DriverObject.GetSettings(InputParameters, ResultData, TimeOut);";
		Выполнить(СтрокаВыражения);
		Если ТипЗнч(Result) <> Тип("Boolean") Тогда
			Result = False;// интерфейс реализован некорркетно - считаем что команду такой "кривой" обработчик тоже не выполнил
			ResultCode = 26;
			ResultDescription = "Ошибка работы метода ""GetSettings"" у обработчика модели  {" + ModelID + "} - неккоректный результат исполнения";
		ИначеЕсли Result Тогда
			ResultCode = 0;
			ResultDescription = "Ошибок нет";
		Иначе // в ВозвратныеПараметрах должно быть описание ошибки
			ResultCode = ResultData.GetValue(0);
			ResultDescription = ResultData.GetValue(1);
		КонецЕсли;
	Исключение
		ResultCode = 27;
		ResultDescription = "Ошибка при вызове команды ""GetSettings"""
		                  + """ у обработчика модели  {" + ModelID + "} возможно некорректная реализация обрабтчика"
		                  + Символы.ПС + "Текст ошибки: " + ОписаниеОшибки();
		Result = False;
	КонецПопытки;
	
	Если Result Тогда
		// Попытаемся достать результат и отдать его в вызваший нас код
		Попытка
			Settings = ResultData.GetValue(0);
		Исключение
			ResultCode = 27;
			ResultDescription = "Ошибка при анализе возвратных параметров  ""GetSettings"""
			                  + """ у обработчика модели  {" + ModelID + "} возможно некорректная реализация обрабтчика"
			                  + Символы.ПС + "Текст ошибки: " + ОписаниеОшибки();
			Result = False;
		КонецПопытки;
	КонецЕсли;
	// Сюда дожны попастьобязательно
	Попытка // Вызовем деструктор самого обаботчика
		DeviceParameters.DriverObject.Close(); // пусть очистит у себя ссылку на нас
		                                       // и другие структуры в своем контексте
	Исключение
	КонецПопытки;

	If NeedClearObjects Then
		// Очистим все ссылки на ненужные нам объекты
		DeviceParameters.DriverObject = Undefined;
		DeviceParameters.Clear();
		DeviceParameters = Undefined;
	EndIf;

	#EndIf

	Return Result;

EndFunction

// Метод вызывается для создания нового экземпляра внешнего оборудования (устройства)
// Входные параметры:
//   DeviceName        - строка, пользовательское наименование экземпляра оборудования
//   ModelID           - строка, GUID модели
//   Settings          - Неопределено, либо SafeArray с набором настроек устройства
//                       в случае передачи значения Неопределено в данном параметре
//                       устройство будет создано с настройками по умолчанию
//   ConnectStr        - (необязательный) строка, содержащая параметры подключения к удаленной станции
//                       содержит сетевое имя (либо адрес) рабочей станции и порт сервера на котором
//                       ожидаются входящие соединяния-запросы на исполнение команд от других станций
//                       Имя и порт серверной станции разделяются двоеточием
//                       Примеры содержимого данного параметра: "SERVERNAME:1500" "10.2.1.5:1500"
// Возвратные параметры:
//   DeviceID          - строка, GUID созданного экземпляра - нужно сохранить в справочнике
//   ResultCode        - число, код возникшей ошибки
//   ResultDescription - строка, описание возникшей ошибки
// Возвращает: значение типа булево - True при успешном выполнении, False в противном случае
Function CreateDevice(DeviceName, ModelID, Settings, DeviceID, ResultCode = 0, ResultDescription = "", ConnectStr = "") Export;

	// Основные рабочие методы менеджера можно вызывать только после его успешной инциализации
	Если НЕ IsInitialized(ResultCode, ResultDescription) Тогда
		Return False; // Код ошибки и ее описание для возврата в вызвавший нас код уже заполнены
	КонецЕсли;

	// Сначала проверки входных параметров на корректность, идентификатор модели
	Если НЕ CheckID(ModelID, ResultCode, ResultDescription) Тогда
		Return False; // Код ошибки и ее описание для возврата в вызвавший нас код уже заполнены
	КонецЕсли;

	#If WebClient Then

	ResultCode = 99;
	ResultDescription = GetMessage(99);
	Return False;

	#Else

	// Создадим набор параметров для нового устройства
	DeviceParameters = CreateDeviceParameters();
	DeviceParameters.DeviceName = DeviceName;
	// Считаем данные только по одной интересующей нас сейчас модели оборудования
	Models = Неопределено;
	Если Not ReadModelsDataFile( , , ModelID, , Models, ResultCode, ResultDescription) Тогда
		Return False; // ResultCode, ResultDescription уже заполнены
	КонецЕсли;
	ModelInfo = Models[0];
	// Используем полученные данные модели
	DeviceParameters.ModelID = ModelID;
	DeviceParameters.TypeName = ModelInfo.TypeName;
	DeviceParameters.ProcessorName = ModelInfo.ProcessorName;
	DeviceParameters.ProcessorType = ModelInfo.ProcessorType;
	DeviceParameters.ExternalEventHook = ModelInfo.ExternalEventHook;
	// Получим экземпляр-абстракт нужной модели оборудования
	Если НЕ CreateDriverObject(DeviceParameters, ResultCode, ResultDescription, True) Тогда
		Return False; // Код ошибки и описание уже заполнены функцией "ПолучитьОбъектОбработчика"
	КонецЕсли;
	
	// Сгенерируем идентификатор нового устройства
	DeviceParameters.DeviceID = Upper(New UUID);
	
	If Not ValueIsFilled(Settings) Then
		// Необходимо получить настройки по умолчанию
		If Not GetDefaultSettings(ModelID, Settings, ResultCode, ResultDescription, , DeviceParameters) Then
			Return False; // ResultCode, ResultDescription уже заполнены
		EndIf;
	EndIf;

	// ! На будущее тут нужно доработать момент чтобы присланные настройки
	// проходили валидацию через объект-обработчик (SetSettings потом обратно GetSettings)
	
	If Not SaveDeviceSettings(DeviceParameters, Settings, ResultCode, ResultDescription) Then
		Return False; // ResultCode, ResultDescription уже заполнены
	EndIf;
	
	// Вернем GUID нового устройства наверх
	DeviceID = DeviceParameters.DeviceID;

	// Объект-абстракт нам более не нужен - уничтожим его
	// (он не прошел все стадии инициализации - им нельзя пользоваться для работы)
	Попытка // Вызовем деструктор объекта-абстракта
		DeviceParameters.DriverObject.Close(); // пусть очистит у себя ссылку на нас и все другие свои внутренние структуры
	Исключение
	КонецПопытки;

	// Очистим ссылки на ненужные нам объекты
	DeviceParameters.DriverObject = Undefined;
	
	// Получим кеш устройств
	DevicesStructure = Undefined;
	GetManagerProperty("DevicesStructure", DevicesStructure);
	// Поместим в кеш устройств структуру параметров нового устройства
	// (она в полном порядке и может быть использована при дальнейшей работе менеджера)
	DevicesStructure.Вставить(GUIDtoID(DeviceID), DeviceParameters);

	Return True;
	#EndIf

EndFunction

// Метод вызывается для удаления экземпляра внешнего оборудования (устройства)
// Входные параметры:
//   DeviceID          - строка, GUID устройства
//   ConnectStr        - (необязательный) строка, содержащая параметры подключения к удаленной станции
//                       содержит сетевое имя (либо адрес) рабочей станции и порт сервера на котором
//                       ожидаются входящие соединяния-запросы на исполнение команд от других станций
//                       Имя и порт серверной станции разделяются двоеточием
//                       Примеры содержимого данного параметра: "SERVERNAME:1500" "10.2.1.5:1500"
// Возвратные параметры:
//   ResultCode        - число, код возникшей ошибки
//   ResultDescription - строка, описание возникшей ошибки
// Возвращает: значение типа булево - True при успешном выполнении, False в противном случае
Function RemoveDevice(DeviceID, ResultCode = 0, ResultDescription = "", ConnectStr = "") Export;

	// Основные рабочие методы менеджера можно вызывать только после его успешной инциализации
	Если НЕ IsInitialized(ResultCode, ResultDescription) Тогда
		Return False; // Код ошибки и ее описание для возврата в вызвавший нас код уже заполнены
	КонецЕсли;

	// Сначала проверки входных параметров на корректность, идентификатор модели
	Если НЕ CheckID(DeviceID, ResultCode, ResultDescription) Тогда
		Return False;
	КонецЕсли;

	// Получим каталог экземпляров оборудования (устройств) из свойств менеджера
	DevicesFolder = "";
	GetManagerProperty("DevicesFolder", DevicesFolder);
	// Определим каталог устройства
	ПутьКДаннымУстройства = DevicesFolder + DeviceID + "\";
	КаталогУстройства = Новый Файл(ПутьКДаннымУстройства);
	// Проверим существование каталога экземпляра оборудования (устройства)
	УстройствоСуществует = КаталогУстройства.Существует();
	Если УстройствоСуществует Тогда
		// Попытамся удалить каталог устройста
		Попытка
			DeleteFiles(КаталогУстройства);
		Исключение
			ResultCode = 53;
			ResultDescription = GetMessage(53, ОписаниеОшибки());
			ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceID);
		КонецПопытки;
		// Проверка после попытки удаления
		КаталогУстройства = Новый Файл(ПутьКДаннымУстройства);
		Result = НЕ КаталогУстройства.Существует();
	Иначе
		Result = False;
		ResultCode = 31;
		ResultDescription = GetMessage(31);
	КонецЕсли;

	Return Result;

EndFunction

// Метод используется для передачи в локальный менеджер информации об удаленном (сетевом) устройстве
// Происходит попытка установления связи с удаленной рабочей станцией обслуживающей это устройство
// Входные параметры:
//   DeviceID      - идентификатор устройства (GUID в виде строки)
//   ConnectStr    - (необязательный) строка, содержащая параметры подключения к удаленной станции
//                   содержит сетевое имя (либо адрес) рабочей станции и порт сервера на котором
//                   ожидаются входящие соединяния-запросы на исполнение команд от других станций
//                   имя и порт серверной станции разделяются двоеточием
//                   Примеры содержимого данного параметра: "SERVERNAME:1500" "10.2.1.5:1500"
//   TimeOut       - число, таймаут ожидания результатов выполнения команды (задается в секундах)
// Выходные параметры:
//   ResultCode         - число, код возникшей ошибки
//   ResultDescription  - строка с описанием возникшей ошибки
// Возвращает:
//   значение типа булево Истина при успешном выполнении, Ложь в противном случае
Function AssignRemoteDevice(Val DeviceID, ConnectStr, TimeOut, ResultCode = 0, ResultDescription = "") Export
	// Сетевой режим работы в данной реализации менеджера не поддерживается
	ResultCode = 81;
	ResultDescription = GetMessage(81);
	Return True;
EndFunction // AssignRemoteDevice

// Метод используется клиенстким приложением для перехвата всех событий генерируемых устройством
// (для этого также должны быть установлены обработчики необходимых типов событий), а также для
// установки режима монопольного использования устройства (только из данного клиентского приложения)
//
// Входные параметры:
//   DeviceID  - идентификатор устройства (GUID в виде строки)
//   Exclusive - булево, если установить True при вызове метода, то использование 
//                                  данного устройства из других приложений будет заблокировано
// Выходные параметры:
//   ResultCode        - число, код возникшей ошибки
//   ResultDescription - строка, текстовое описание ошибки
// Возвращает: значение типа булево - True при успешном выполнении, False в противном случае
Function Claim(DeviceID, Exclusive = False, ResultCode = 0, ResultDescription = "") Export

	Return False;

EndFunction

// Метод используется клиенстким приложением для отмены перехвата событий генерируемых устройством
// Входные параметры:
//   DeviceID  - идентификатор устройства (GUID в виде строки)
// Выходные параметры:
//   ResultCode        - число, код возникшей ошибки
//   ResultDescription - строка, текстовое описание ошибки
// Возвращает: значение типа булево - True при успешном выполнении, False в противном случае
Function Release(DeviceID, ResultCode = 0, ResultDescription = "") Export

	Return True;

EndFunction

// ------------------------------------------------------------------------------------------------
// - МЕТОДЫ МЕНЕДЖЕРА реализующий интерфейс взаимодействия с загруженными обработчиками устройств)-
// ------------------------------------------------------------------------------------------------

// Метод предназначен для передачи события с данными из обработчика устройства
// в систему управления оборудованием например, событие считывания штрих-кода сканером
// Входные параметры:	
//   Source		- строка содержащая идентификатор источника (оборудования, либо асихронной команды)
//   Event		- строка содержащая вид события (если оборудование может генерировать разные виды событий, также регламентируется на уровне типа)
//   Data		- строка с кратким представлением данных события (например считанный штрих-код или данные магнитной карты, формат может быть задан в настройках устройства
//   ExtData		- необязательный SafeArray
// Возвращает:	строку с именем нажатой пользователем кнопки или пустую строку если истек таймаут
Function DataEvent(Source, Event, Data, ExtData = НЕОПРЕДЕЛЕНО) Export
	Result = False;  // Мы должны вернуть обработчику Истина только если кто-нибудь "съест" его данные

	Result = DataEventToApplication(Source, Event, Data, ExtData);

	// Возвращаем обработчику устройства результат обработки его события
	Return Result; // Истина - если событие было обработано
EndFunction // DataEvent

// Метод предназначен для периодического вызова из обработчика 
// с целью предоставления информации о прогрессе исполнения команды и
// продлении установленного в параметрах вызова таймаута ее выполнения
// Входные параметры:	Source		- идентификатор источника (оборудование либо асинхронной команды)
//   Percent		- число, значение в % прогресса исполнения текущей команды
//   TextStatus	- строка с текстовым описанием состояния команды (не обязательный параметр)
// Возвращает:	булев тип, 	Истина сигнализирует обработчику что он может продолжать исполнение команды (продлевается таймаут)
//   	Ложь   сигнализирует обработчику что команда отменена, результат ее исполнения не нужен, рекомендуется прервать (при возможности) исполнение текущей команды
Function TaskState(Source, Percent, TextStatus = "") Export
	Result = True; // Мы должны возвращать обработчику Истина чтобы он продолжал работать
	// Для начала проверим что за устройство прислало нам событие
	// потому что если это устройство выполняет чью-то команду удаленно (по сети)
	// то это событие необходимо передать обратно по сети заказчику этой команды
	DeviceParameters = НЕОПРЕДЕЛЕНО;
	// Если ПолучитьПараметрыОборудования(Source, DeviceParameters) Тогда
	//	Если НЕ ПустаяСтрока(DeviceParameters.CommandID) Тогда // Точно исполняется удаленная команда 
	//		Если НЕ DeviceParameters.IsNowConnected Тогда // Только вот произошла неприятность соединение-то уже разорвано к настоящему моменту
	//			// на тот конец все равно уже ничего передать не сможем 
	//			Return Ложь; // имеет смысл сообщить обработчику чтобы прекратил зря надрываться
	//		КонецЕсли;
	//		// Нужно "прокинуть" это событие через сеть
	//		Result = МенеджерСетевогоВзаимодействия.SendTaskState(DeviceParameters, Percent, TextStatus);
	//		Return Result; // Все выходим местному клинтскому приложению этот TaskState не нужен
	//	КонецЕсли;			
	// КонецЕсли;
	// Здесь передаем события от всех локальных устройств нашему клиентскому приложению
	Result = TaskStateToApplication(Source, Percent, TextStatus);
	Return Result; // Ложь - если исполнение команды необходимо прервать
EndFunction // TaskState

// Метод предназначен для передачи информации о возникновении аварийного состояния в
// оборудовании из обработчика в систему управления оборудованием (и далее в клиентское
// приложениекое, если последнее установила обработчик для событий данного типа
// Входные параметры:
//   Source       - строка содержащая идентификатор оборудования
//   ErrorType    - строка содержащая вид ошибки (если оборудование 
//   Может генерировать разные виды событий, также регламентируется на уровне типа)
//   Description  - строка с кратким описанием ошибочного состояния
//   ExtData      - необязательный, SafeArray с дополнительными данными 
// Возвращает: строку с именем нажатой пользователем кнопки или пустую строку если истек таймаут
Function ErrorEvent(Source, ErrorType, Description, ExtData = НЕОПРЕДЕЛЕНО) Export
	Result = False;  // Мы должны вернуть обработчику Истина только если кто-нибудь "съест" его данные
	// Проверим что за устройство прислало нам событие
	// это устройство захвачено (Claimed) кем-то удаленно (по сети)
	// то это данное событие необходимо передать обратно по сети тому кто его захватил
	DeviceParameters = НЕОПРЕДЕЛЕНО;
	// Если ПолучитьПараметрыОборудования(Source, DeviceParameters) Тогда
	//	Если НЕ ПустаяСтрока(DeviceParameters.ClaimID) Тогда // Точно есть захват!
	//		// Нужно "прокинуть" это событие через сеть
	//		Result = МенеджерСетевогоВзаимодействия.SendErrorEvent(DeviceParameters, ErrorType, Description, ExtData);
	//		Return Result; // Все выходим, местному клиентскому приложению этот ErrorEvent не нужен
	//	КонецЕсли;			
	// КонецЕсли;
	// Здесь передаем события от всех локальных устройств нашему клиентскому приложению
	Result = ErrorEventToApplication(Source, ErrorType, Description, ExtData);
	// Возвращаем обработчику устройства результат обработки его события
	Return Result; // Истина - если событие было обработано
EndFunction // ErrorEvent

// Предназначено для передачи интерактивного запроса от оборудования к пользователю
// Внимание! Не рекомендуется использовать данный метод кроме как для исключительных 
// ситуаций в которых совершенно необходимо получить интерактивную реакцию пользователя
// Входные параметры:	Source	- идентификатор устройства (GUID в виде строки)
//   Message		- строка с сообщением (вопросом) пользователю
//   Type		- число, тип диалога (0-предупреждение, 1-информация, 2-вопрос)
//   Buttons		- строка с перечнем кнопок, доступных пользователю в виде "Да+Нет" (должны соответствовать возможностям диалогов 1С)
//   TimeOut		- число > 0, предельное время ожидание реакции пользователя в модальном диалоге
// Возвращает:	строку с именем нажатой пользователем кнопки или пустую строку если истек таймаут
Function MessageDlg(Source, Message, Type=0, Buttons="OK", TimeOut=60) Export
	Result = ""; // Если не было реакции пользователя (произошел таймаут) то возвращается пустая строка
	// Проверим что за устройство прислало нам событие,
	// Если это устройство захвачено (Claimed) кем-то удаленно (по сети)
	// то это данное событие необходимо передать обратно по сети тому кто его захватил
	DeviceParameters = НЕОПРЕДЕЛЕНО;
	// Если ПолучитьПараметрыОборудования(Source, DeviceParameters) Тогда
	//	Если НЕ ПустаяСтрока(DeviceParameters.ClaimID) Тогда // Точно есть захват!
	//		// Нужно "прокинуть" этот запрос через сеть
	//		Result = МенеджерСетевогоВзаимодействия.SendMessageDlg(DeviceParameters, Message, Type, Buttons, TimeOut);
	//		Return Result; // Все выходим, местному клиентскому приложению этот ErrorEvent не нужен
	//	КонецЕсли;			
	// КонецЕсли;
	// Здесь передаем события от всех локальных устройств нашему клиентскому приложению
	Result = MessageDlgToApplication(Source, Message, Type, Buttons, TimeOut);
	// Возвращаем обработчику устройства результат обработки его события
	Return Result; // Имя нажатой кнопки, либо пустая строка если был Timeout
EndFunction // MessageDlg

// Метод используется для создания структуры входных и выходных параметров
// Входные параметры:
//   MaxIndex0 - число, количество строк двумерного массива или элементов одномерного
//   MaxIndex1 - число, 0 для создания одномернрого массива или число колонок для двумерного
// Возвращает: значение типа SafeArray
Function CreateArray(MaxIndex0, MaxIndex1 = 0) Export

	Если MaxIndex1 > 0 Тогда
		Result = Новый COMSafeArray("VT_VARIANT", MaxIndex0, MaxIndex1);
	Иначе
		Result = Новый COMSafeArray("VT_VARIANT", MaxIndex0);
	КонецЕсли;

	Return Result;

EndFunction

// Метод используется для передачи отладочной информации обработчиков устройств
// для последующей их записи в единый журнал, либо лог-файл
// Входные параметры:
//   Source       - строка содержащая идентификатор оборудования
//   Event        - строка содержащая вид информации (если оборудование может генерировать разные виды)
//   Description  - строка содержащая детальный текст отладочной информации
//   Type         - строка содержащая категорию отлдадочной информации: Information Error DebugLog
// Возвращает: булев результат процедуры записи информации в журнал, либо в лог-файл
Function WriteLog(Source, Event, Description, Type = "Information") Export

	IsDebugMode = Undefined;
	If GetManagerProperty("IsDebugMode", IsDebugMode) AND IsDebugMode Then
		#If ThinClient OR WebClient Then
			// Логгирование нужно реализовывать другими средствами
			// ...
		#Else
			// Можно воспользоваться стандартным журналом регистрации событий
			UppedType = Upper(Type);
			If Find(UppedType, "ERROR") > 0 Then
				Level = EventLogLevel.Error;
			ElsIf Find(UppedType, "INFO")  > 0 Then
				Level = EventLogLevel.Information;
			Else
				Level = EventLogLevel.Warning;
			EndIf;
			WriteLogEvent(Source + "." + Event, Level, , , Description);
		#EndIf
	EndIf;

	Return True;

EndFunction

// ------------------------------------------------------------------------------------------------
// --- ЭКСПОРТНЫЕ МЕТОДЫ МЕНЕДЖЕРА (интерфейс предоставляемый для компоненты сетевого траспорта) ---
// ------------------------------------------------------------------------------------------------

// Метод используется для передачи принятых по сети данных
// от компоненты сетевого траспорта в систему управления оборудованием
// Входные параметры:	CommandID - идентификатор команды (GUID в виде строки) в разрезе которой получены данные
//   DataArray - SafeArray с данными переданными по сети (от удаленного менеджера оборудования)
// Возвращает:	всегда Истина
Function NetworkData(CommandID, DataArray) Export
	Result = True;	// У компоненты транспорта нет обработчика на отказ принять уже полученные
					// по сети данные, поэтому всегда возвращаем ей истину
	Попытка
//		Result = МенеджерСетевогоВзаимодействия.NetworkData(CommandID, DataArray);
	Исключение
		WriteLog("NetworkData","Исключение в NetworkData - " + ОписаниеОшибки(), "Error");
	КонецПопытки;
	Return Result;
EndFunction

// Метод используется для передачи информации о событии разъединения соединения
// от компоненты сетевого траспорта в систему управления оборудованием
// Входные параметры:	CommandID	- идентификатор команды (GUID в виде строки) в разрезе которой получено данное событие
// Возвращает:	всегда Истина
Function DisconnectEvent(CommandID = Undefined) Export
	Result = True; // Всегда истину возвращаем
	Попытка
	// Result = МенеджерСетевогоВзаимодействия.DisconnectEvent(CommandID);
	Исключение
	КонецПопытки;
	Return Result;
EndFunction

// -------------------------------------------------------------------------------------------------
// - Служебные и внутренние методы менеджера внешнего оборудования
// -------------------------------------------------------------------------------------------------

// Function возвращает мажор-версию системы оборудования
// применяется в системе взаимного контроля версий
// объектов (менеджеров) и обработчиков
Function GetSystemMajorVersion() Export
	Return 1;
EndFunction

// Function возвращает минор-версию системы оборудования
// применяется в системе взаимного контроля версий
// объектов (менеджеров) и обработчиков
Function GetSystemMinorVersion() Export
	Return 0;
EndFunction

// Внутренняя функция менеджера для передачи событий DataEvent его клиентскому приложению
Function DataEventToApplication(Source, Event, Data, ExtData = НЕОПРЕДЕЛЕНО);
	Result = False; // По умолчанию если событие не обработано то возвращаем Ложь чтобы обработчик не удалил его из буфера
	DataEventHandler = "";
	GetManagerProperty("DataEventHandler", DataEventHandler);
	Если НЕ ПустаяСтрока(DataEventHandler) Тогда
		// Похоже клиенсткое приложение установило обработчик этого типа событий
		Application = Undefined;
		GetManagerProperty("Application", Application);
		Если Application <> Undefined Тогда
			СтрокаВыражения = "Result = Application." + DataEventHandler + "(Source, Event, Data, ExtData);";
			Попытка // попытаемся отдать событие в процедуру клиентского приложения
				Выполнить(СтрокаВыражения);
				Если ТипЗнч(Result) <> Тип("Булево") Тогда
					Result = False; // Если тип неверный значит перехватчик некорректный и вряд ли он там событие обработал правильно
				КонецЕсли;
			Исключение
				Result = False; // Данные не обработаны клиентским приложением, пусть останутся в буфере устройства
				ResultDescription = GetMessage(55) +Символы.ПС+ GetMessage(2, ОписаниеОшибки());
				ResultDescription = ResultDescription + Символы.ПС + GetMessage(56);
				ResultDescription = StrReplace(ResultDescription, "%Type%", "DataEvent");
				ResultDescription = StrReplace(ResultDescription, "%Source%", Source);
				ResultDescription = StrReplace(ResultDescription, "%EventName%", Event);
				ResultDescription = StrReplace(ResultDescription, "%HandlerName%", DataEventHandler);
				WriteLog("DataEvent", ResultDescription, "Error");
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	// Возвращаем результат обработки
	Return Result; // Истина если событие было обработано
EndFunction // DataEventToApplication

// Внутренняя функция менеджера для передачи событий TaskState его клиентскому приложению
Function TaskStateToApplication(Source, Percent, TextStatus = "");
	Result = True; // По умолчанию прерывать обработку команды не нужно пусть себе доработает до конца
	TaskStateHandler = "";
	GetManagerProperty("TaskStateHandler", TaskStateHandler);
	Если НЕ ПустаяСтрока(TaskStateHandler) Тогда
		Application = Undefined;
		GetManagerProperty("Application", Application);
		Если Application <> Undefined Тогда
			СтрокаВыражения = "Result = Application." + TaskStateHandler + "(Source, Percent, TextStatus);";
			Попытка // попытаемся отдать событие в процедуру клиентского приложения
				Выполнить(СтрокаВыражения);
				Если ТипЗнч(Result) <> Тип("Булево") Тогда
					Result = False; // Если тип неверный значит перехватчик некорректный и вряд ли он там событие обработал правильно
				КонецЕсли;
			Исключение
				Result = True;  // Мы должны возвращать обработчику Истина чтобы он продолжал работать
				ResultDescription = GetMessage(55) + Символы.ПС + GetMessage(54) + GetMessage(2,ОписаниеОшибки()) + GetMessage(56);
				ResultDescription = StrReplace(ResultDescription, "%Type%", "TaskState");
				ResultDescription = StrReplace(ResultDescription, "%Source%", Source);
				ResultDescription = StrReplace(ResultDescription, "%EventName%", TextStatus);
				ResultDescription = StrReplace(ResultDescription, "%HandlerName%", TaskStateHandler);
				WriteLog("TaskState", ResultDescription, "Error");
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	Return Result; // Ложь - если исполнение команды необходимо прервать
EndFunction // TaskStateToApplication

// Внутренняя функция менеджера для передачи событий ErrorEvent его клиентскому приложению
Function ErrorEventToApplication(Source, ErrorType, ErrorDescription, ExtData = НЕОПРЕДЕЛЕНО);
	Result = False; // По умолчанию если событие не обработано то возвращаем Ложь чтобы обработчик не удалил его из своего буфера
	// Если НЕ ПустаяСтрока(ErrorEventHandler) Тогда
	//	// Похоже клиенсткое приложение установило обработчик этого типа событий
	//	СтрокаВыражения = "Result = " + ErrorEventHandler + "(Source, ErrorType, ErrorDescription, ExtData);";
	//	Попытка // попытаемся отдать событие в процедуру клиентского приложения
	//		Выполнить(СтрокаВыражения);
	//		Если ТипЗнч(Result) <> ТипБулево Тогда
	//			Result = False; // Если тип не булево значит обработчик точно неправильный и вряд ли он там событие обработал правильно
	//		КонецЕсли;
	//	Исключение
	//		Result = False;
	//		ResultDescription 	= "Ошибка перенаправления вызова ErrorEvent в клиентское приложения от источника {" + Source + "}"
	//   	+ Символы.ПС + "Текст ошибки: " + ОписаниеОшибки()
	//   	+ Символы.ПС + "Возможно некорректная реализация функции ErrorEvent в клиентском приложении";
	//		WriteLog("ErrorEvent", ResultDescription, "Error");
	//	КонецПопытки;
	// КонецЕсли;
	// Возвращаем результат обработки
	Return Result; // Истина если событие было обработано
EndFunction // ErrorEventToApplication

// Внутренняя функция менеджера для передачи запроса MessageDlg клиентскому приложению
Function MessageDlgToApplication(Source, Message, Type, Buttons, TimeOut);
	Result = ""; // По умолчанию если пользователь не отреагировал на диалог то возвращатся пустая строка как таймаут
	// Если НЕ ПустаяСтрока(MessageDlgHandler) Тогда
	//	// Похоже клиенсткое приложение установило обработчик этого типа событий
	//	СтрокаВыражения = "Result = " + MessageDlgHandler + "(Source, Message, Type, Buttons, TimeOut);";
	//	Попытка // попытаемся отдать событие в процедуру клиентского приложения
	//		Выполнить(СтрокаВыражения);
	//		Если ТипЗнч(Result) <> ТипСтрока Тогда
	//			Result = ""; // Если тип не строка значит обработчик точно неправильный и вряд ли он там событие обработал правильно
	//		КонецЕсли;
	//	Исключение
	//		Result = False;
	//		ResultDescription 	= "Ошибка перенаправления вызова MessageDlg в клиентское приложения от источника {" + Source + "}"
	//   	+ Символы.ПС + "Текст ошибки: " + ОписаниеОшибки()
	//   	+ Символы.ПС + "Возможно некорректная реализация функции MessageDlg в клиентском приложении";
	//		WriteLog("MessageDlg", ResultDescription, "Error");
	//	КонецПопытки;
	// КонецЕсли;
	// Возвращаем результат обработки
	Return Result; // Истина если событие было обработано
EndFunction // MessageDlgToApplication

// Преобразует тип булево в строкове значение для записи в XML атрибут
Function BooleanToString(Значение);
	Возврат ?(Значение,"True","False");
EndFunction

// Преобразует сохраненные в XML многострочные данные
Function StringFromXML(StringFromXML)

	Result = StrReplace(StringFromXML, "\\n", Символы.ВТаб);
	Result = StrReplace(Result, "\n", Символы.ПС);
	Result = StrReplace(Result, Символы.ВТаб, "\n");

	Return Result;

EndFunction

// Преобразует разделители в многострочных строках
// для их корректного сохранения в атрибутах XML
Function StringToXML(Str)

	Result = СтрЗаменить(Str, "\\n", Символы.ВТаб);
	Result = СтрЗаменить(Result, Символы.ПС, "\n");
	Result = СтрЗаменить(Result, Символы.ВТаб, "\n");

	Return Result;

EndFunction

// Проверка переданного идентификатора на корректность
// приведение одному виду: UUID с верхним регистром всех символов
Function CheckID(DeviceID, ResultCode, ResultDescription)

	Result = False;

	Если ТипЗнч(DeviceID) <> Тип("Строка") Тогда
		ResultCode = 41;
		ResultDescription = GetMessage(41);
	ИначеЕсли ПустаяСтрока(DeviceID) Тогда
		ResultCode = 42;
		ResultDescription = GetMessage(42);
	ИначеЕсли (СтрДлина(DeviceID) = 36) Тогда
		Result = True;
	ИначеЕсли СтрДлина(DeviceID = 38) И (Лев(DeviceID, 1) = "{") И (Прав(DeviceID, 1) = "}") Тогда
		DeviceID = Сред(DeviceID, 2, 36);
		Result = True;
	Иначе
		ResultCode = 43;
		ResultDescription = GetMessage(43);
	КонецЕсли;

	Если Result Тогда
		DeviceID = ВРег(DeviceID);
		Для Индекс=1 По 36 Цикл
			ПроверимКод = КодСимвола(DeviceID, Индекс);
			Если (ПроверимКод = 45) ИЛИ ((ПроверимКод >= 48) И (ПроверимКод <= 57)) ИЛИ ((ПроверимКод >= 65) И (ПроверимКод <= 70)) Тогда
				// Рарешен символ "-", между "0" и "9"  между "A" и "F"
			Иначе
				ResultCode = 44;
				ResultDescription = GetMessage(44);
				Return False; // Сразу выходим из функции прерывая цикл
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Return Result;

EndFunction

// Проверка переданной команды на корректность
// и приведение к верхнему регистру всех символов
Function CheckCommand(CommandName, ResultCode, ResultDescription)

	Если ТипЗнч(CommandName) <> Тип("Строка") Тогда
		ResultCode = 45;
		ResultDescription = GetMessage(45);
		Return False;
	ИначеЕсли ПустаяСтрока(CommandName) Тогда
		ResultCode = 46;
		ResultDescription = GetMessage(46);
		Return False;
	Иначе
		CommandName = ВРЕГ(CommandName);
		Для Индекс=1 По StrLen(CommandName) Цикл
			ПроверимКод = КодСимвола(CommandName, Индекс);
			Если ((ПроверимКод >= 48) И (ПроверимКод <= 57)) ИЛИ ((ПроверимКод >= 65) И (ПроверимКод <= 90)) Тогда
				// символ между "0" и "9" или между "A" и "Z" - допускается, идем дальше по циклу
			Иначе
				ResultCode = 47;
				ResultDescription = GetMessage(47);
				Return False; // Сразу выходим из функции прерывая цикл
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Return True;

EndFunction

// Проверяет корректность переданного в параметрах файлового пути и
// возможность записи в него (права доступа на создание/изменение файлов)
Function IsPathWriteAble(PathName, ResultCode, ResultDescription)

	ФС = Новый Файл(PathName);
	Если НЕ ФС.Существует() Тогда
		Попытка
			СоздатьКаталог(PathName);
		Исключение
			ResultCode = 8;
			ResultDescription = GetMessage(23)
			                  + Символы.ПС + PathName
			                  + Символы.ПС + GetMessage(2, ОписаниеОшибки())
			                  + Символы.ПС + GetMessage(24);
			Return False;
		КонецПопытки;
	ИначеЕсли НЕ ФС.ЭтоКаталог() Тогда
		ResultCode = 9;
		ResultDescription = GetMessage(25) + Символы.ПС + PathName;
		Return False;
	КонецЕсли;

	// Проверим можем ли мы писать в этот каталог
	Result = False;
	ИмяФайла = Строка(Новый УникальныйИдентификатор()); // Чтобы не "пересекались" ни при каких вариантах
	ИмяФайла = ИмяФайла + ".TMP"; // По такому расширению удобно чистить будет
	Док = Новый ТекстовыйДокумент();
	Док.Вывод = ИспользованиеВывода.Разрешить; // на случай, если у пользователя нет права Вывод
	Док.УстановитьТекст("Writable test at " + ТекущаяДата()+ " - Ok");
	Попытка
		Док.Записать(PathName + ИмяФайла, КодировкаТекста.ANSI);
	Исключение
	КонецПопытки;
	Док = Неопределено;
	// Проверим создался ли наш файлик
	ФС = Новый Файл(PathName + ИмяФайла);
	Если ФС.Существует() И ФС.ЭтоФайл() Тогда
		Result = True;
		Попытка
			УдалитьФайлы(PathName, "*.TMP");
		Исключение
		КонецПопытки;
	Иначе
		ResultCode = 10;
		ResultDescription = GetMessage(26)
		                  + Символы.ПС + PathName 
		                  + Символы.ПС + GetMessage(2, ОписаниеОшибки())
		                  + Символы.ПС + GetMessage(27);
		Return False;
	КонецЕсли;
	ФС = Неопределено;

	Return Result;

EndFunction

// Возвращает булев результат проверки инициализирован ли текущий
// объект менеджера (готов выполнять свои функции)
// Возвратные параметры:
//   ResultCode          - число, код ошибки для возврата в вызвавший код
//   ResultDescription   - строка, в которой возвращается текстовое описание ошибки
Function IsInitialized(ResultCode = 0, ResultDescription = "") Export

	IsInitialized = False;
	If Not GetManagerProperty("IsInitialized", IsInitialized) Then
		IsInitialized = False;
	EndIf;
	If IsInitialized Then
		ResultCode = 0;
		ResultDescription = GetMessage(0);
	Else
		ResultCode = 1;
		ResultDescription = GetMessage(1); // не был инициализирован и не может исполнять свои методы
	EndIf;

	Return IsInitialized;

EndFunction

// Возвращает булев результат проверки инициализирован ли текущий
// объект менеджера на работу в сетевом режиме (с удаленными устройствами)
Function IsNetworkMode() Export
	Result = False;
	// Проверим инициализирован ли уже сетевой режим работы
	If Not GetManagerProperty("IsNetworkMode", Result) Then
		Result= False;
	EndIf;
	Return Result;
EndFunction

// Возвращает уникальный идентификатор текущей рабочей сессии
Function GetSessionID()
	Result = "";
	GetManagerProperty("SessionID", Result);
	Return Result;
EndFunction

// Проверяет наличие обработчика, загружает и инициализирует его 
// Входные параметры:	
//  DeviceParameters  - структура с параметрами устройства
//  GetAbstract       - булево, признак необходимости создать неинициализированный объект-абстракт
//                      применяется в цикле создания нового экземпляра оборудования
// Выходные параметры:
//  ResultCode        - числовой код ошибки
//  ResultDescription - строка с описанием возникшей ошибки
Function CreateDriverObject(DeviceParameters, ResultCode = 0, ResultDescription = "", GetAbstract = Ложь);

	Если GetAbstract Тогда
		// Нужен обработчик не для конкретного устройства, а объект-абстракт типа, точнее модели
		DeviceParameters.DeviceID = "Object-Abstract_" + DeviceParameters.ProcessorName;
	КонецЕсли;

	Попытка // будем пытаться загрузить обработчик
		Если DeviceParameters.ProcessorType = 1 Тогда
			// Системная реализация обработчика
			Попытка
				DeviceParameters.DriverObject = Новый COMОбъект(DeviceParameters.ProcessorName);
			Исключение
				DeviceParameters.DriverObject = Неопределено;
				ResultCode = 63;
				ResultDescription = GetMessage(63) + Символы.ПС + ОписаниеОшибки();
				ResultDescription = StrReplace(ResultDescription, "%Processor%", DeviceParameters.ProcessorName);
				ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
				Return False;
			КонецПопытки;
		Иначе
			ResultCode = 64;
			ResultDescription = GetMessage(64);
			ResultDescription = StrReplace(ResultDescription, "%Type%", DeviceParameters.ProcessorType);
			Return False;
		КонецЕсли;
		Попытка // Производим попытку первоначальную инициализацию обработчика
			// Необходимо передать в объект-обработчик собственный контекст, чтобы он мог обращаться через него
			// нашим интерфесным функциям обратного вызова DataEvent, TaskState, ErrorEvent, MessageDlg
			Если Не DeviceParameters.DriverObject.Init(МенеджерОборудованияСтандартныеДрайвераКлиент, ResultDescription) Тогда
				DeviceParameters.DriverObject = Неопределено;
				ResultCode = 65;
				Return False;
			КонецЕсли;
		Исключение
			DeviceParameters.DriverObject = Неопределено;
			ResultCode = 66;
			ResultDescription = GetMessage(66) + Символы.ПС + ОписаниеОшибки();
			ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
			Return False;
		КонецПопытки;
		Если GetAbstract Тогда
			DeviceParameters.DeviceID = "Object-Abstract_" + DeviceParameters.ProcessorName;
			Return True; // Таким образом получим объект-абстракт с настройками по умолчанию
		Иначе
			// Получаем настройки устройства из схемы
			Settings = Неопределено;
			Если Не ReadDeviceSettings(DeviceParameters, Settings, ResultCode, ResultDescription) Тогда
				DeviceParameters.DriverObject = Неопределено;
				Return False;
			КонецЕсли;
			Попытка // Передаем полученные настройки в контекст объекта-обработчика
				ПараметрВозврата = Неопределено;
				ВходнойПараметр = CreateArray(1);
				ВходнойПараметр.SetValue(0, Settings);
				Result = DeviceParameters.DriverObject.SetSettings(ВходнойПараметр, ПараметрВозврата, 0);
				Если Result Тогда // Обработчик принял настройки 
					RefreshCommandTimeOut(DeviceParameters);
				Иначе
					DeviceParameters.DriverObject = Неопределено;
					ResultCode = 67;
					ResultDescription = GetMessage(67) + Символы.ПС + Строка(ПараметрВозврата.GetValue(1));
					ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
					Return False;
				КонецЕсли;
			Исключение
				DeviceParameters.DriverObject = Неопределено;
				ResultCode = 68;
				ResultDescription = GetMessage(68) + Символы.ПС + ОписаниеОшибки();
				ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
				Возврат Ложь;
			КонецПопытки;
			// Установка соответствия с конкретным экземпляром оборудования
			Попытка 
				Result = DeviceParameters.DriverObject.Open(DeviceParameters.DeviceID, ResultDescription);
			Исключение
				// Нет метода
				DeviceParameters.DriverObject = Неопределено;
				ResultCode = 69;
				ResultDescription = GetMessage(69) + Символы.ПС + ОписаниеОшибки();
				ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
				Return False;
			КонецПопытки;
		КонецЕсли;
	Исключение
		DeviceParameters.DriverObject = Неопределено;
		ResultCode = 60;
		ResultDescription = GetMessage(60) + ОписаниеОшибки();
		Return False;
	КонецПопытки;

	Return True;

EndFunction

// Получение параметров устройства из таблицы-кеша устройств
// Входные параметры:
//   DeviceID            - строка, содержит уникальный идентификатор устройства
// Выходные параметры:   
//   DeviceParameters    - структура параметров, соответствующая экземпляру устройства
//   ResultCode          - числовой код возникшей ошибки
//   ResultDescription   - строка, текстовое описание возникшей ошибки
// Возвращает: булево значение - результат успешности свой работы
Function GetDeviceParameters(Знач DeviceID, DeviceParameters, ResultCode = 0, ResultDescription = "")

	// Сначала проверки входных параметров на корректность, идентификатор
	Если НЕ CheckID(DeviceID, ResultCode, ResultDescription) Тогда
		Return False;
	КонецЕсли;

	// Получим кеш рабочих параметров всех задействованых устройств
	DevicesStructure = Undefined;
	Если Not GetManagerProperty("DevicesStructure", DevicesStructure, ResultCode, ResultDescription) Then
		Return False;
	КонецЕсли;
	
	// Попытаемся получить параметры для текущего устройства из кеша
	DeviceParameters = Undefined;
	Если DevicesStructure.Property(GUIDtoID(DeviceID), DeviceParameters) Then
		Return True; // получили - возвращаем
	КонецЕсли;

	// Не было еще обращений к экзепляру с заданным идентификатором, создаем новую структуру параметров
	DeviceParameters = CreateDeviceParameters();
	// Необходимо найти во внешнем хранилище базовую информацию по устройству (узнаем идентификатор модели)
	Если НЕ ReadDeviceParameters(DeviceID, DeviceParameters, ResultCode, ResultDescription) Тогда
		Return False; // ResultCode, ResultDescription уже заполнены
	КонецЕсли;
	
	// Остальные данные полуим из описания моделей, считаем только одну интересующую нас сейчас модель
	ModelsList = Неопределено;
	Если Not ReadModelsDataFile( , , DeviceParameters.ModelID, , ModelsList, ResultCode, ResultDescription) Тогда
		Return False; // ResultCode, ResultDescription уже заполнены
	КонецЕсли;
	ModelInfo = ModelsList[0];
	// Используем данные из модели для заполения остальных параметров устройства
	DeviceParameters.ProcessorName = ModelInfo.ProcessorName;
	DeviceParameters.ProcessorType = ModelInfo.ProcessorType;
	DeviceParameters.ExternalEventHook = ModelInfo.ExternalEventHook;
	// Поместим в общий кеш устройств полученные данные
	DevicesStructure.Вставить(GUIDtoID(DeviceID), DeviceParameters);

	// Вернем успешный результат
	Return True;

EndFunction

// Получает информацию о параметрах устройства из внешнего хранилища настроек
Function ReadDeviceParameters(Знач DeviceID, DeviceParameters, ResultCode = 0, ResultDescription = "")

	#If WebClient Then

	ResultCode = 99;
	ResultDescription = GetMessage(99);
	Return False;

	#Else

	Result = False;
	DevicesFolder = "";
	GetManagerProperty("DevicesFolder", DevicesFolder);
	ПутьКДаннымУстройства = DevicesFolder + DeviceID + "\";
	КаталогУстройства = Новый Файл(ПутьКДаннымУстройства);
	Если НЕ КаталогУстройства.Существует() ИЛИ НЕ КаталогУстройства.ЭтоКаталог() Тогда
		ResultCode = 31;
		ResultDescription = GetMessage(31);
		ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceID);
		Return False;
	КонецЕсли;
	
	ИмяФайлаНастроек = ПутьКДаннымУстройства + "Settings.xml";
	ФайлНастроек = Новый Файл(ИмяФайлаНастроек);
	Если Не ФайлНастроек.Существует() Или Не ФайлНастроек.ЭтоФайл() Тогда
		ResultCode = 32;
		ResultDescription = GetMessage(32);
		ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceID);
		Return False;
	КонецЕсли;

	ЧтениеXML = Новый ЧтениеXML;

	Попытка

		ЧтениеXML.ОткрытьФайл(ИмяФайлаНастроек);

		TypeName = "";
		DeviceName = "";
		ModelID = "";
		ProcessorName = "";
		ProcessorType = "";
		MajorVersion = 0;
		MinorVersion = 0;
		ExternalEventHook = Ложь;
		
		Пока ЧтениеXML.Прочитать() Цикл
			
			Если ЧтениеXML.КоличествоАтрибутов() > 0 Тогда
				Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
					// Обработка атрибутов
					Если ЧтениеXML.Имя = "TypeName" Тогда
						TypeName = ЧтениеXML.Значение;
						Продолжить;
					КонецЕсли;
					Если ЧтениеXML.Имя = "DeviceName" Тогда
						DeviceName = ЧтениеXML.Значение;
						Продолжить;
					КонецЕсли;
					Если ЧтениеXML.Имя = "ModelID" Тогда
						ModelID = ВРег(ЧтениеXML.Значение);
						Продолжить;
					КонецЕсли;
					Если ЧтениеXML.Имя = "DeviceID" Тогда
						FileDeviceID = ВРег(ЧтениеXML.Значение);
						Если DeviceID <> FileDeviceID Тогда
							ResultCode = 33;
							ResultDescription = GetMessage(33);
							ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
							Return False; // Либо fake-файл, либо не тот узел XML читаем, в любом случае дальше нам тут дальше делать нечего
						КонецЕсли;
					КонецЕсли;
					// Проверим получили ли уже то что нам нужно было
					Если ПустаяСтрока(TypeName)
						ИЛИ ПустаяСтрока(DeviceName)
						ИЛИ ПустаяСтрока(FileDeviceID)
						ИЛИ ПустаяСтрока(ModelID) Тогда
							Продолжить; // впереди каких-то атрибутов добавили? ладно пойдем дальше в поисках "наших"
					Иначе
							Прервать; // все что нужно уже получили, а если в будущем добавится еще атрибутов мы их так здесь проигнорируем
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			// Проверим получили ли мы базовые данные об устройстве
			Если ПустаяСтрока(TypeName) ИЛИ ПустаяСтрока(DeviceName) ИЛИ ПустаяСтрока(FileDeviceID) ИЛИ ПустаяСтрока(ModelID) Тогда
				// Вот на этот момент эти атрибуты у нас должны быть, а если их нет это серьезная ошибка
				ResultCode = 34;
				ResultDescription = GetMessage(34);
				ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
				Return False; // Либо fake-файл, либо не тот узел XML читаем - в любом случае дальше нам тут делать нечего
			Иначе 
				// уже получили все базовые данные, заполняем в структуру
				DeviceParameters.DeviceID = DeviceID;
				DeviceParameters.DeviceName = DeviceName;
				DeviceParameters.TypeName = TypeName;
				DeviceParameters.ModelID = ModelID;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		// Раз уж открыли файл с настройками дочитаем его до конца заодно загрузив настройки устройства
		ЧтениеXML.ПерейтиКСодержимому();
		Пока ЧтениеXML.Прочитать() Цикл
			Если (ЧтениеXML.Имя <> "Item")
			 ИЛИ (ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента)
			 ИЛИ (ЧтениеXML.КоличествоАтрибутов() < 7) Тогда
				Продолжить; // Выбираем только настройки устройства
			КонецЕсли;

			SettingData = Undefined;
			// Считаем атрибуты очередной настройки в структуру SettingData
			Если НЕ ReadSettingData(ЧтениеXML, SettingData, ResultCode, ResultDescription) Тогда
				Return False;
			КонецЕсли;
			// Пополним набор настроек данными прочитанной настройки (ID - ключ для удобства доступа к конкретной настройке)
			DeviceParameters.StrucOfSettings.Insert(SettingData.ID, SettingData);

		КонецЦикла; // по узлам в документе XML

		Result = True;

	Исключение
		ResultDescription = GetMessage(35) + Символы.ПС + ОписаниеОшибки();
		ResultCode = 35;
		Result = False;
	КонецПопытки;

	ЧтениеXML.Закрыть();
	ЧтениеXML = Неопределено;

	Return Result;

	#EndIf

EndFunction

// Создает пустую структуру параметров устройства
Function CreateDeviceParameters()

	DeviceParameters = Новый Структура(
		"DeviceID,DeviceName,TypeName,ModelID,ComputerName,PortNumber,ProcessorName,ProcessorType,StatusCode,"
		+"StatusName,IsNetworkDevice,DriverObject,CommandTimeOut,TimeOutExpire,CommandID,IsNowConnected,"
		+"NetworkData,CommandName,ClaimID,OwnerID,OwnerName,ExclusiveOwner,ExternalEventHook,StrucOfSettings",
		"","","","","",0,"",0,0,"Выключено",Ложь,Неопределено,30,ТекущаяДата(),"",Ложь,
		Неопределено,"","","","",Ложь,Ложь,Новый Структура);

	Возврат DeviceParameters;

EndFunction

// Обновляет значение таймаута исполнения команд в параметрах устройства
Процедура RefreshCommandTimeOut(DeviceParameters)

	Если ValueIsFilled(DeviceParameters.StrucOfSettings) Тогда
		DefaultTimeOut = DeviceParameters.StrucOfSettings.DefaultTimeOut.Value;
		DeviceParameters.CommandTimeOut = MAX(DefaultTimeOut, 10); // На случай если кто меньше 10 сек поставит
	КонецЕсли;

КонецПроцедуры

// Преобразует GUID в правильный идентификатор
// для возможности его использования в качестве ключа структуры
Function GUIDtoID(GUID)

	Result = GUID;
	If StrLen(GUID) = 38 Then
		// на случай если из системного драйвера пришел в формате Windows API
		Result = Mid(GUID, 2, 36);
	EndIf;
	Result = StrReplace(Result,"-","");
	Result = "ID" + Upper(Result);

	Return Result;

EndFunction

// Проверяет существование файла описания моделей во внешнем хранилище настроек
// Входные параметры:
//   ModelDescFileName   - (необязательный), строка, полное имя файла описания моделей
// Выходные параметры:
//   ResultCode          - числовой код возникшей ошибки
//   ResultDescription   - строка, текстовое описание возникшей ошибки
// Возвращает: булево значение - результат успешности свой работы
Function ExistModelsDescription(ModelDescFileName, ResultCode, ResultDescription)

	ModelsFolder = "";
	Если  НЕ GetManagerProperty("ModelsFolder", ModelsFolder) OR TypeOf(ModelsFolder) <> Type("String") Тогда
		ModelsFolder = "";
	КонецЕсли;

	Если ПустаяСтрока(ModelsFolder) Тогда
		ResultCode = 12;
		ResultDescription = GetMessage(4) + Символы.ПС + GetMessage(5);
		Return False;
	КонецЕсли;
	
	ModelDescFileName = ModelsFolder + "Models.xml";
	ФайлМоделей = Новый Файл(ModelDescFileName);
	Если НЕ ФайлМоделей.Существует() ИЛИ НЕ ФайлМоделей.ЭтоФайл() ИЛИ (ФайлМоделей.Размер()<102) Тогда
		ResultCode = 13;
		ResultDescription = GetMessage(6)
		                  + Символы.ПС + ModelsFolder
		                  + Символы.ПС + GetMessage(7);
		Return False;
	КонецЕсли;

	Return True;

EndFunction

// Осуществляет чтение одного элемента описания модели
// при разборе общего файла описания моделей (Models.xml)
// помещает считанные параметры в структуру
// Входные параметры:
//   XMLReadObject     - объект чтения XML, спозиционированный на очередном элементе описания модели
// Выходные параметры:
//   StrucOfModelData  - структура, в нее помещаются считанные атрибуты модели
//   ResultCode        - числовой код возникшей ошибки
//   ResultDescription - строка, текстовое описание возникшей ошибки
// Возвращает: булево значение - результат успешности свой работы
Function ReadModelParameters(XMLReadObject, StrucOfModelData, ResultCode = 0, ResultDescription = "")
	Попытка
			StrucOfModelData = Новый Структура("ModelName,TypeName,ProcessorName,ProcessorType,MajorVersion,MinorVersion,
				                               |BuildVersion,Developer,ContactInfo,ExternalEventHook,ModelID,Description",
				                               XMLReadObject.ПолучитьАтрибут("ModelName"),
				                               XMLReadObject.ПолучитьАтрибут("TypeName"),
				                               XMLReadObject.ПолучитьАтрибут("ProcessorName"),
				                               Число(XMLReadObject.ПолучитьАтрибут("ProcessorType")),
				                               Число(XMLReadObject.ПолучитьАтрибут("MajorVersion")),
				                               Число(XMLReadObject.ПолучитьАтрибут("MinorVersion")),
				                               Число(XMLReadObject.ПолучитьАтрибут("BuildVersion")),
				                               XMLReadObject.ПолучитьАтрибут("Developer"),
				                               XMLReadObject.ПолучитьАтрибут("ContactInfo"),
				                               BooleanToString(XMLReadObject.ПолучитьАтрибут("ExternalEventHook")),
				                               ВРег(XMLReadObject.ПолучитьАтрибут("ModelID")),
				                               XMLReadObject.ПолучитьАтрибут("Description"));
		Result = True;
	Исключение
		ResultCode = 23;
		ResultDescription = GetMessage(28) + ОписаниеОшибки();
		Result = False;
	КонецПопытки;

	Return Result;
EndFunction

// Функция осуществляет преобразование считанного атрибуа из XML
// в значение требуемого типа
Function ConvertValueByType(Value, Type, ResultValue, ResultCode, ResultDedcription)
	
	// Получим структуру описаний разрешенных типов из свойств менеджера
	StrucOfTypes = Неопределено;
	GetManagerProperty("StrucOfTypes", StrucOfTypes);
	// Получим описание нужного типа из структуры разрешеных типов
	TypeDescObject = Неопределено;
	Если НЕ StrucOfTypes.Property(Type, TypeDescObject) Тогда
		// Типа не оказалось в нашей структуре - значит тип "неправильный"
		ResultCode = 39;
		ResultDescription = GetMessage(39);
		Return False;
	КонецЕсли;

	// Попытаемся преобразовать в значение нужного типа
	Попытка
		Если Type = "String" Тогда
			// Заменим разделители строк на переводы строки (для многострочных значений)
			ResultValue = StringFromXML(Value);
		ИначеЕсли Type = "Number" Тогда
			ResultValue = TypeDescObject.AdjustValue(Value);
		ИначеЕсли Type = "Date" Тогда
			ResultValue = TypeDescObject.AdjustValue(Value);
		ИначеЕсли Type = "Boolean" Тогда
			ResultValue = TypeDescObject.AdjustValue(Value);
		Иначе
			ResultCode = 39;
			ResultDescription = GetMessage(39);
			Return False;
		КонецЕсли;
		Result = True;
	Исключение
		ResultCode = 38;
		ResultDescription = GetMessage(38, ОписаниеОшибки());
		Result = False;
	КонецПопытки;

	Return Result;

EndFunction

// Осуществляет чтение одного элемента настройки устройства
// при разборе файла настроек конкретного устройства (Settings.xml)
Function ReadSettingData(XMLReadObject, SettingData, ResultCode =0, ResultDescription ="")

	Попытка // Вызвавший данную функцию код не должен валится из-за ошибок разобра XML к примеру
		// Подготовим переменные в которые будут считаны атрибуты настройки 
		// (переменные с префиксом х будут подвергнуты преобразованию типа значения)
		ID = "";
		xValue = "";
		Type = "";
		xDefault = "";
		xReadOnly = НЕОПРЕДЕЛЕНО;
		Name = "";
		xDescription = "";
		// Считаем атрибуты из XML
		Пока XMLReadObject.СледующийАтрибут() Цикл
			ИмяАтрибута = XMLReadObject.Имя;
			ЗнчАтрибута = XMLReadObject.Значение;
			Если ИмяАтрибута = "ID" Тогда
				ID = ЗнчАтрибута;
				Продолжить;
			ИначеЕсли ИмяАтрибута = "Value" Тогда
				xValue = ЗнчАтрибута;
				Продолжить;
			ИначеЕсли ИмяАтрибута = "Type" Тогда
				Type = ЗнчАтрибута;
				Продолжить;
			ИначеЕсли ИмяАтрибута = "Default" Тогда
				xDefault = ЗнчАтрибута;
				Продолжить;
			ИначеЕсли ИмяАтрибута = "ReadOnly" Тогда
				xReadOnly = ЗнчАтрибута;
				Продолжить;
			ИначеЕсли ИмяАтрибута = "Name" Тогда
				Name = ЗнчАтрибута;
				Продолжить;
			ИначеЕсли ИмяАтрибута = "Description" Тогда
				xDescription = ЗнчАтрибута;
				Продолжить;
			Иначе // неизвестный нам атрибут игнорируем
			КонецЕсли;
		КонецЦикла; // по атрибутам в узле XML

		// Проконтролируем чтобы все необходмые данные были считаны
		Если ПустаяСтрока(ID) ИЛИ ПустаяСтрока(Type)
			ИЛИ (ПустаяСтрока(xValue) И (Type <> "String")) // Пустая строка допустима в качестве значения строкового типа
			ИЛИ (ПустаяСтрока(xDefault) И (Type <> "String")) // Пустая строка допустима в качестве значения по умолчанию
			ИЛИ ПустаяСтрока(Name) ИЛИ ПустаяСтрока(xReadOnly) Тогда
			// Не все атрибуты настройки заполнены в файле - ошибочная структура файла описания устройства
			ResultCode = 36;
			ResultDescription = GetMessage(36) + ID;
			Return False;
		КонецЕсли;

		// В эти переменные положим значения преобразованные в нужный тип
		Value = "";
		Default = "";
		ReadOnly = НЕОПРЕДЕЛЕНО;
		Description = "";

		// Приведение типов значений
		Если НЕ ConvertValueByType(xValue, Type, Value, ResultCode, ResultDescription) Тогда
			ResultDescription = StrReplace(ResultDescription, "%Value%", xValue);
			ResultDescription = StrReplace(ResultDescription, "%ID%", ID);
			Return False;
		КонецЕсли;
		Если НЕ ConvertValueByType(xDefault, Type, Default, ResultCode, ResultDescription) Тогда
			ResultDescription = StrReplace(ResultDescription, "%Value%", xDefault);
			ResultDescription = StrReplace(ResultDescription, "%ID%", ID);
			Return False;
		КонецЕсли;
		Если НЕ ConvertValueByType(xReadOnly, "Boolean", ReadOnly, ResultCode, ResultDescription) Тогда
			ResultDescription = StrReplace(ResultDescription, "%Value%", xReadOnly);
			ResultDescription = StrReplace(ResultDescription, "%ID%", ID);
			Return False;
		КонецЕсли;
		Если НЕ ConvertValueByType(xDescription, "String", Description, ResultCode, ResultDescription) Тогда
			ResultDescription = StrReplace(ResultDescription, "%Value%", xDescription);
			ResultDescription = StrReplace(ResultDescription, "%ID%", ID);
			Return False;
		КонецЕсли;

		// Заполним данные настройки
		SettingData = Новый Структура("ID,Value,Type,Default,ReadOnly,Name,Description",
		                           ID,
		                           Value,
		                           Type,
		                           Default,
		                           ReadOnly,
		                           Name,
		                           Description);

		Result = True;

	Исключение
		ResultDescription = GetMessage(35) + Символы.ПС + ОписаниеОшибки();
		ResultCode = 35;
		Result = False;
	КонецПопытки;

	Return Result;

EndFunction

// Метод предназначен для считывания из внешнего хранилища значений
// данных об установленных моделях оборудования 
// Входные параметры:
//   ModelDescFileName  - строка, полный путь к файлу описания моделей
//   NeedAttribs        - многострочная строка, перечисляющая идентификаторы атрибутов, которые необходимо считать
//   NeedModels         - многострочная строка, перечисляющая идентификаторы моделей, которые необходимо считать,
//                        допускатеся передавать значение "*" для считывания всех установленных в системе моделей
// Возвратные параметры:
//   Attribs            - в данный параметр будет помещена структура со значениями атрибутов (ключ - имя атрибута)
//   ArrayOfModel       - массив будут помещаться структуры описания найденных моделей (ключ имя, значение свойство)
//   ResultCode         - число, если метод не выполнил свою задау и возвращает отрицательный результат,
//                        то в данном параметре возвращается код возникшей ошибки
//   ResultDescription  - строка, в которой возвращается текстовое описание ошибки
// Возвращает:
//   булево значение как результат своего исполнения
Function ReadModelsDataFile(ModelDescFileName = "",
	                        NeedAttribs = "",
	                        NeedModels = "*",
	                        Attribs = Undefined,
	                        ArrayOfModel = Undefined,
	                        ResultCode = 0,
	                        ResultDescription = "")

	#If WebClient Then

	ResultCode = 99;
	ResultDescription = GetMessage(99);
	Return False;

	#Else

	Result = False; // На данном тапе положительный результат еще не достигнут

	Если ПустаяСтрока(ModelDescFileName) Тогда
		GetManagerProperty("ModelsFolder", ModelDescFileName);
		ModelDescFileName = ModelDescFileName + "Models.xml";
	КонецЕсли;

	ЧтениеXML = Новый ЧтениеXML;

	Попытка // Разбирать будем в попытке чтобы вызвавший нас код не уронить

		ЧтениеXML.ОткрытьФайл(ModelDescFileName);
		
		Если НЕ ПустаяСтрока(NeedAttribs) Тогда
			// Нужно считать заданные атрибуты заголовка
			AttribsMax = StrLineCount(NeedAttribs);
			AttribsCnt = 0;
			Attribs = Новый Структура;
			Пока ЧтениеXML.Прочитать() Цикл
				Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
					AttribName = ЧтениеXML.Имя;
					Если Найти(NeedAttribs, AttribName) > 0 Тогда
						Attribs.Insert(AttribName,ЧтениеXML.Значение);
						AttribsCnt = AttribsCnt + 1;
					КонецЕсли;
					Если AttribsCnt = AttribsMax Тогда
						Прервать; // Нашли уже что искали - заканчиваем чтение
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			Если AttribsCnt = AttribsMax Тогда
				Result = True;
			Иначе
				ResultCode = 21; // Некорректная структура XML-файла
				ResultDescription = GetMessage(9) +Символы.ПС + GetMessage(8);
				Return False;
			КонецЕсли;
		КонецЕсли;

		Если НЕ ПустаяСтрока(NeedModels) Тогда
			// Нужно считать параметры заданных моделей
			ЧтениеXML.ПерейтиКСодержимому();
			ArrayOfModel = Новый Массив;
			Пока ЧтениеXML.Прочитать() Цикл
				Если ЧтениеXML.КоличествоАтрибутов() = 0  Тогда
					Продолжить; // Это не элемент описания модели
				КонецЕсли;
				StrucOfModelData = Undefined;
				Если НЕ ReadModelParameters(ЧтениеXML, StrucOfModelData, ResultCode, ResultDescription) Тогда
					Return False;
				КонецЕсли;
				// ТекущийИдМодели = ВРег(ЧтениеXML.ПолучитьАтрибут("ModelID"));
				// Если (NeedModels = "*") ИЛИ Найти(NeedModels, ТекущийИдМодели) > 0 Тогда
				Если (NeedModels = "*") ИЛИ Найти(NeedModels, StrucOfModelData.ModelID) > 0 Тогда
					// Проверим что считали
					Если StrucOfModelData.MajorVersion = GetSystemMajorVersion() Тогда
						ArrayOfModel.Add(StrucOfModelData); // Добавили описание считанной модели
						Продолжить; // Читаем файл моделей дальше
					ИначеЕсли NeedModels = "*" Тогда
						Продолжить; // Когда запросили общий список установленных моделей, некорректные можно просто игнорировать
					Иначе
						// Когда запрашивают конкретную модель а она не подходит по контролю версий то это уже ошибка
						ResultCode = 25;
						ResultDescription = GetMessage(10) + Символы.ПС
										  + """" + StrucOfModelData.ModelName + """" + Символы.ПС
										  + GetMessage(11) + StrucOfModelData.ModelID + Символы.ПС
										  + GetMessage(12) + StrucOfModelData.MajorVersion
										  + StrucOfModelData.MinorVersion + StrucOfModelData.BuildVersion + Символы.ПС
										  + GetMessage(13) + StrucOfModelData.Developer + Символы.ПС
										  + GetMessage(14) + StrucOfModelData.ContactInfo + Символы.ПС;
						Return False;
					КонецЕсли;
				Иначе
					Продолжить; // Нам нужно сейчас описание другой модели оборудования
				КонецЕсли;
			КонецЦикла;

			// Проверим достигнутый результат
			Если NeedModels = "*" Тогда
				Если ArrayOfModel.Количество() > 0 Тогда
					Result = True;
				Иначе
					ResultCode = 26;
					ResultDescription = GetMessage(15) + Символы.ПС + GetMessage(16);
					Result = False;
				КонецЕсли;
			ИначеЕсли ArrayOfModel.Количество() = StrLineCount(NeedModels) Тогда
				Result = True;
			Иначе
				ResultCode = 27;
				ResultDescription = GetMessage(17) + Символы.ПС + GetMessage(8);
				Return False;
			КонецЕсли;
		КонецЕсли;
	Исключение
		ResultCode = 20; // Некорректная структура XML-файла
		ResultDescription = GetMessage(18) + ОписаниеОшибки()+ Символы.ПС + GetMessage(8);
		Result = False;
	КонецПопытки;

	ЧтениеXML.Закрыть();
	ЧтениеXML = Неопределено;

	Return Result;

	#EndIf

EndFunction

// Метод предназначен для считывания из внешнего хранилища значений
// данных конкретного экзмепляра оборудования (устройства)
// Входные параметры:
//   DeviceParameters   - структура, содержащая необходимую для работы менеджера информацию об устройстве
// Возвратные параметры:
//   Settings           - в параметр будет помещен структура из структур со значениями настроек устройства
//   ResultCode         - число, если метод не выполнил свою задау и возвращает отрицательный результат,
//                        то в данном параметре возвращается код возникшей ошибки
//   ResultDescription  - строка, в которой возвращается текстовое описание ошибки
// Возвращает:
//   булево значение как результат своего исполнения
Function ReadDeviceSettings(DeviceParameters, Settings, ResultCode = 0, ResultDescription = "")

	#If WebClient Then

	ResultCode = 99;
	ResultDescription = GetMessage(99);
	Return False;

	#Else

	Result = False; // Пока еще ничего не сделали - результата нет
	DevicesFolder = "";
	GetManagerProperty("DevicesFolder", DevicesFolder);
	ПутьКДаннымУстройства = DevicesFolder + DeviceParameters.DeviceID + "\";
	КаталогУстройства = Новый Файл(ПутьКДаннымУстройства);
	Если НЕ КаталогУстройства.Существует() ИЛИ НЕ КаталогУстройства.ЭтоКаталог() Тогда
		ResultCode = 31;
		ResultDescription = GetMessage(31);
		ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
		Return Result; // False
	КонецЕсли;
	
	ИмяФайлаНастроек = ПутьКДаннымУстройства + "Settings.xml";
	ФайлНастроек = Новый Файл(ИмяФайлаНастроек);
	Если Не ФайлНастроек.Существует() Или Не ФайлНастроек.ЭтоФайл() Тогда
		ResultCode = 32;
		ResultDescription = GetMessage(32);
		ResultDescription = StrReplace(ResultDescription, "%FileName%", ИмяФайлаНастроек);
		Return Result; // False
	КонецЕсли;

	ЧтениеXML = Новый ЧтениеXML;
	Попытка
		ЧтениеXML.ОткрытьФайл(ФайлНастроек.ПолноеИмя);
		ЧтениеXML.ПерейтиКСодержимому();
		Пока ЧтениеXML.Прочитать() Цикл
			Если (ЧтениеXML.Имя <> "Item") 
			 ИЛИ (ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента)
			 ИЛИ (ЧтениеXML.КоличествоАтрибутов() < 7) Тогда
				Продолжить; // Выбираем только настройки устройства
			КонецЕсли;

			SettingData = Undefined;
			// Считаем атрибуты очередной настройки в структуру SettingData
			Если НЕ ReadSettingData(ЧтениеXML, SettingData, ResultCode, ResultDescription) Тогда
				// Ошибка структуры файла информации об устройстве Settings.xml
				ResultDescription = GetMessage(37) + Chars.LF + ResultDescription;
				ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
				Return Result; // False
			КонецЕсли;
			// Пополним набор настроек данными прочитанной настройки (ID - ключ для удобства доступа к конкретной настройке)
			DeviceParameters.StrucOfSettings.Insert(SettingData.ID, SettingData);
		КонецЦикла;

		// Перепакуем данные в SafeArray
		ВсегоНастроек = DeviceParameters.StrucOfSettings.Количество();
		Settings = CreateArray(ВсегоНастроек, 7);
		Индекс = 0;
		Для Каждого SetRow ИЗ DeviceParameters.StrucOfSettings Цикл
			Settings.SetValue(Индекс, 0, SetRow.Value.ID);
			Settings.SetValue(Индекс, 1, SetRow.Value.Value);
			Settings.SetValue(Индекс, 2, SetRow.Value.Type);
			Settings.SetValue(Индекс, 3, SetRow.Value.Default);
			Settings.SetValue(Индекс, 4, SetRow.Value.ReadOnly);
			Settings.SetValue(Индекс, 5, SetRow.Value.Name);
			Settings.SetValue(Индекс, 6, SetRow.Value.Description);
			Индекс = Индекс +1;
		КонецЦикла;

		Result = True;

	Исключение
		Result = False;
		ResultDescription = GetMessage(35) + Символы.ПС + ОписаниеОшибки();
		ResultCode = 35;
	КонецПопытки;

	ЧтениеXML.Закрыть();
	ЧтениеXML = Неопределено;

	Return Result;

	#EndIf

EndFunction // ПрочитатьНастройкиИзФайла

// Функция выполняет запись типизированного аттрибута в XML-файл
// согласно принятым форматам преобразования примитивных типов в строковое представление
// Входные параметры:
//   XMLwriteObject     - объект записи XML
//   Name               - строка, имя записываемого атрибута
//   Type               - строка, имя типа записываемого атрибута
//   Value              - значение примитивного типа, значение записываемого аттрибута
// Возвратные параметры:
//   ResultCode         - число, если метод не выполнил свою задау и возвращает отрицательный результат,
//                        то в данном параметре возвращается код возникшей ошибки
//   ResultDescription  - строка, в которой возвращается текстовое описание ошибки
// Возвращает:
//   булево значение как результат своего исполнения
Function WriteAttributeByType(XMLwriteObject, Name, Type, Value, ResultCode, ResultDescription)

	Если Type = "String" Тогда
		Presentatation = StringToXML(Value);
	ИначеЕсли Type = "Number" Тогда
		Presentatation = Format(Value,"NDS='.';NG=0;NZ=");
	ИначеЕсли Type = "Date" Тогда
		Presentatation = Format(Value,"DF=dd.MM.yyyy hh:mm:ss");
	ИначеЕсли Type = "Boolean" Тогда
		Presentatation = BooleanToString(Value);
	Иначе
		ResultCode = 39;
		ResultDescription = GetMessage(39);
		Return False
	КонецЕсли;

	XMLwriteObject.WriteAttribute(Name, Presentatation);
	Return True;

EndFunction

// Записывает набор настроек устройства в хранилище настроек
// Входные параметры:
//  DeviceID          - идентификатор устройства (GUID в виде строки)
// ..Settings          - SafeArray массив с полным набором настроек
// Возвратные параметры:
//  ResultDescription - строка, описание возникшей ошибки
// Возвращает:           значение типа булево Истина при успешном выполнении, Ложь в противном случае
Function SaveDeviceSettings(DeviceParameters, Settings, ResultCode = 0, ResultDescription = "")

	#If WebClient Then

	ResultCode = 99;
	ResultDescription = GetMessage(99);
	Return False;

	#Else
	
	ФлагОшибки = Ложь; // Пока никаких ошибок не возникло
	
	// Получим каталог экземпляров оборудования (устройств) из свойств менеджера
	DevicesFolder = "";
	GetManagerProperty("DevicesFolder", DevicesFolder);
	ПутьКДаннымУстройства = DevicesFolder + DeviceParameters.DeviceID + "\";
	КаталогУстройства = Новый Файл(ПутьКДаннымУстройства);
	// Проверим существование каталога экземпляра оборудования (устройства)
	Если НЕ КаталогУстройства.Существует() Тогда
		Попытка // Попробуем создать
			СоздатьКаталог(ПутьКДаннымУстройства);
		Исключение
			ResultDescription = ОписаниеОшибки();
		КонецПопытки;
		// Проверка после попытки создания
		КаталогУстройства = Новый Файл(ПутьКДаннымУстройства);
		Если НЕ КаталогУстройства.Существует() Тогда
			ResultCode = 48;
			ResultDescription = GetMessage(48) + ПутьКДаннымУстройства + Символы.ПС + ResultDescription;
			ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
			Return False;
		КонецЕсли;
	КонецЕсли;

	// Откроем запись во временный файл сначала, а когда все будет готово переименуем его
	ИмяВременногоФайла = ПутьКДаннымУстройства + "Settings.tmp";
	
	Попытка
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла, "UTF-16");
		ЗаписьXML.ЗаписатьОбъявлениеXML();
		ЗаписьXML.ЗаписатьНачалоЭлемента("DeviceConfig");
		ЗаписьXML.ЗаписатьАтрибут("TypeName", DeviceParameters.TypeName);
		ЗаписьXML.ЗаписатьАтрибут("DeviceName", DeviceParameters.DeviceName);
		ЗаписьXML.ЗаписатьАтрибут("ModelID", DeviceParameters.ModelID);
		ЗаписьXML.ЗаписатьАтрибут("DeviceID", DeviceParameters.DeviceID);
		// Начали раздел Settings
		ЗаписьXML.ЗаписатьНачалоЭлемента("Settings");
		КоличествоНастроек = Settings.GetLength();
		Для НомерСтроки = 0 По КоличествоНастроек - 1 Цикл
			
			// Получим все атрибуты очередной настройки из массива настроек
			ID = Settings.GetValue(НомерСтроки, 0);          // Идентификатор настройки
			Value = Settings.GetValue(НомерСтроки, 1);       // Текущее значение настройки
			Type = Settings.GetValue(НомерСтроки, 2);        // Строковое представлениетипа значения настройки
			Default= Settings.GetValue(НомерСтроки, 3);      // Значение настройки по умолчанию
			ReadOnly = Settings.GetValue(НомерСтроки, 4);    // Признак нередактируемой настройки
			Name = Settings.GetValue(НомерСтроки, 5);        // Наименование (пользовательское представление) настройки
			Description = Settings.GetValue(НомерСтроки, 6); // Подробное описание настройки

			// Открываем новый элемент описания настройки (Item)
			ЗаписьXML.ЗаписатьНачалоЭлемента("Item");
			// и начинаем писать в него атрибуты текущей настройки
			ЗаписьXML.ЗаписатьАтрибут("ID", ID);
			// Запись типизированного значения настройки согласно принятым форматам записи значений
			Если НЕ WriteAttributeByType(ЗаписьXML, "Value", Type, Value, ResultCode, ResultDescription) Тогда
				// Прерывавем дальнейшую обработку
				ResultDescription = StrReplace(ResultDescription, "%Type%", Type);
				ResultDescription = StrReplace(ResultDescription, "%ID%", ID);
				ФлагОшибки = Истина;
				Прервать;
			КонецЕсли;
			ЗаписьXML.ЗаписатьАтрибут("Type", Type);
			// Запись типизированного значения по умолчанию согласно принятым форматам записи значений
			Если НЕ WriteAttributeByType(ЗаписьXML, "Default", Type, Default, ResultCode, ResultDescription) Тогда
				// Прерывавем дальнейшую обработку
				ResultDescription = StrReplace(ResultDescription, "%Type%", Type);
				ResultDescription = StrReplace(ResultDescription, "%ID%", ID);
				ФлагОшибки = Истина;
				Прервать;
			КонецЕсли;
			// Завершаем запись простых атрибутов
			ЗаписьXML.ЗаписатьАтрибут("ReadOnly", BooleanToString(ReadOnly));
			ЗаписьXML.ЗаписатьАтрибут("Name", Name);
			ЗаписьXML.ЗаписатьАтрибут("Description", StringToXML(Description));
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Конец элемента настройки Item
		КонецЦикла;
		
		Если ФлагОшибки Тогда
			Result = False; // Код и описание уже заполнены
		Иначе
			ЗаписьXML.ЗаписатьКонецЭлемента(); // закрываем раздел Settings
			ЗаписьXML.ЗаписатьКонецЭлемента(); // закрываем корневой раздел DeviceConfig
			ЗаписьXML.Закрыть();

			// Вот теперь уже полностью сформированным временным файлом перезаписываем настоящий
			ПереместитьФайл(ИмяВременногоФайла,ПутьКДаннымУстройства + "Settings.xml");
			// Вот только теперь достигнут положительный результат
			Result = True;
		КонецЕсли;

	Исключение
		Result = False;
		ResultCode = 49;
		ResultDescription = GetMessage(49) + Символы.ПС + ОписаниеОшибки();
		ResultDescription = StrReplace(ResultDescription, "%DeviceID%", DeviceParameters.DeviceID);
	КонецПопытки;

	ЗаписьXML = НЕОПРЕДЕЛЕНО;

	Return Result;

	#EndIf

EndFunction

// Создает массив допустимых типов
Function FillStrucOfTypes()
	
	StrucOfTypes = Новый Структура;
	StrucOfTypes.Вставить("String", Новый ОписаниеТипов("String"));
	StrucOfTypes.Вставить("Number", Новый ОписаниеТипов("Number"));
	StrucOfTypes.Вставить("Date", Новый ОписаниеТипов("Date"));
	StrucOfTypes.Вставить("Boolean",Новый ОписаниеТипов("Boolean"));

	Return StrucOfTypes;

EndFunction

// Получает локализованное сообщение по его коду
Function GetMessage(Code, AddText = "")

	ArrayOfMessages = Undefined;
	If GetManagerProperty("ArrayOfMessages", ArrayOfMessages) Then
		Try 
			Result = ArrayOfMessages[Code];
		Except
			Result = NStr("ru='Ошибка получения описания для кода = '") + Code + Chars.LF 
			       + NStr("ru='Возможно разработчик не поместил локализованное описание для данного кода'");
		EndTry;
	Else
		Result = NStr("ru='Не загружен массив локализованных сообщений'") + Chars.LF
		       + NStr("ru='Невозможно получить сообщение для кода = '") + Code;
	EndIf;

	If Not IsBlankString(AddText) Then
		Result = Result + " - " + AddText;
	EndIf;

	Return Result;
	
EndFunction

// Создает массив текстовых сообщений
Function FillArrayOfMessages()

	AoM = New Array; // ArrayOfMessages
	AoM.Add(NStr("ru='Нет ошибок'"));																// 0
	AoM.Add(NStr("ru='Менеджер управления внешним оборудованием не был инициализирован и не может исполнять свои функции'")); // 1
	AoM.Add(NStr("ru='Текст ошибки: '"));															// 2
	AoM.Add(NStr("ru='Не удалось определить каталог установки программ в системе.'"));				// 3
	AoM.Add(NStr("ru='Менеджер внешнего оборудования не был успешно инициализирован'"));			// 4
	AoM.Add(NStr("ru='не определен каталог установки системы управления внешним оборудованием'"));	// 5
	AoM.Add(NStr("ru='Не обнаружены файлы системы управления оборудованием в каталоге:'"));			// 6
	AoM.Add(NStr("ru='Возможно система управления внешим оборудованием не была установлена'"));		// 7
	AoM.Add(NStr("ru='Возможно необходимо переустановить систему управления оборудованием'"));		// 8
	AoM.Add(NStr("ru='Не найдены все необходимые атрибуты в файле описания моделей'"));				// 9
	AoM.Add(NStr("ru='Обнаружена несовместимость версий системы и драйвера модели'"));				// 10
	AoM.Add(NStr("ru='Идентификатор модели: '"));													// 11
	AoM.Add(NStr("ru='Версия модели: '"));															// 12
	AoM.Add(NStr("ru='Разработчик: '"));															// 13
	AoM.Add(NStr("ru='Контактная информация: '"));													// 14
	AoM.Add(NStr("ru='Не найдено ни одного описания модели.'"));									// 15
	AoM.Add(NStr("ru='Возможно на рабочем месте не было установлено ни одной модели оборудования'"));// 16
	AoM.Add(NStr("ru='Не найдены запрошенные описания моделей во внешнем хранилище настроек.'"));	// 17
	AoM.Add(NStr("ru='Ошибка при разборе основного файла хранилища настроек Models.xml - '"));		// 18
	AoM.Add(NStr("ru='Отсутствуют данные о каталоге устройств в файле: '"));						// 19
	AoM.Add(NStr("ru='Внутренняя ошибка при инициализации драйвер менеджера - '"));					// 20
	AoM.Add(NStr("ru='Свойство менеджера ""%PropertyName%"" нельзя изменять после инициализации менеджера'")); // 21
	AoM.Add(NStr("ru='Внутренния ошибка при установке нового значения свойства менеджера - '"));	// 22
	AoM.Add(NStr("ru='Не удалось создать каталог для экземпляров оборудования:'"));					// 23
	AoM.Add(NStr("ru='Возможно у текущего пользователя нет прав записи.'"));						// 24
	AoM.Add(NStr("ru='Ошибочные данные в Models.xml. Остутствует каталог:'"));						// 25
	AoM.Add(NStr("ru='Ошибка при проверке прав записи в каталог:'"));								// 26
	AoM.Add(NStr("ru='Проверьте права доступа и настройки антивирсуных файл-мониторов.'"));			// 27
	AoM.Add(NStr("ru='Ошибка чтения атрибутов модели при разборе файла Models.xml' - "));			// 28
	AoM.Add(NStr("ru='Исключение при получения свойства менеджера ""%PropertyName%""'"));			// 29
	AoM.Add(NStr("ru='Свойство менеджера ""%PropertyName%"" не доступно для изменения'"));			// 30
	AoM.Add(NStr("ru='Нет данных об устройстве {%DeviceID%} во внешнем хранилище настроек'"));		// 31
	AoM.Add(NStr("ru='Не обнаружен файл настроек устройства: {%DeviceID%} во внешнем хранилище настроек'"));// 32
	AoM.Add(NStr("ru='Несовпадает идентификатор устройства {%DeviceID%} с данными в его файле настроек'"));// 33
	AoM.Add(NStr("ru='Отсутствуют необходимые данные в описании устройства {%DeviceID%}'"));		// 34
	AoM.Add(NStr("ru='Ошибка при разборе файла настроек Settings.xml, возможно некорректная структура файла'")); // 35
	AoM.Add(NStr("ru='Ошибка структуры файла настроек устройства - не все атрибуты заполнены для настройки с ID = '"));// 36
	AoM.Add(NStr("ru='Ошибка при разборе файла настроек Settings.xml, для устройства {%DeviceID%}:'"));// 37
	AoM.Add(NStr("ru='Ошибка преобразования значения атрибута %Value% для настройки %ID%'"));		// 38
	AoM.Add(NStr("ru='Недопустимый тип значения %Type% для настройки %ID%'"));						// 39
	AoM.Add(NStr("ru='Ошибка - переданы некорректные входные параметры'"));							// 40
	AoM.Add(NStr("ru='Идентификатор должен иметь строковый тип'"));									// 41
	AoM.Add(NStr("ru='Идентификатор не может быть пустой строкой'"));								// 42
	AoM.Add(NStr("ru='Переданный идентификатор имеет некорректную  длину'"));						// 43
	AoM.Add(NStr("ru='Переденный идентификатор содержит недопустимые символы'"));					// 44
	AoM.Add(NStr("ru='Команда должна иметь строковый тип'"));										// 45
	AoM.Add(NStr("ru='Команда не может быть пустой строкой'"));										// 46
	AoM.Add(NStr("ru='В переданной команде содержатся недопустимые символы или знаки'"));			// 47
	AoM.Add(NStr("ru='Не удалось создать каталог для устройства {%DeviceID%}'"));					// 48
	AoM.Add(NStr("ru='Ошибка формирования файла настроек устройства {%DeviceID%} Возможно файл был заблокирован'"));// 49
	AoM.Add(NStr("ru='Ошибка при попытке сохранить новые настройки устройства {%DeviceID%} - '"));	// 50
	AoM.Add(NStr("ru='Внутренняя ошибка при составлении списка устройств'"));						// 51
	AoM.Add(NStr("ru='В системе управления оборудованием не было определено ни одного устройства.'")); // 52
	AoM.Add(NStr("ru='Не удалось удалить информацию об устройстве {%DeviceID%} из-за ошибки'")); 	// 53
	AoM.Add(NStr("ru='Источник {%Source%} Событие ""%Event%""'"));									// 54
	AoM.Add(NStr("ru='Ошибка перенаправления в клиентское приложения события типа %Type%'"));		// 55
	AoM.Add(NStr("ru='Возможно некорректная реализация обработчика ""%HandlerName%"" в приложении.'")); // 56
	AoM.Add(NStr("ru=''"));		// 57
	AoM.Add(NStr("ru=''"));		// 58
	AoM.Add(NStr("ru=''"));		// 59
	AoM.Add(NStr("ru='Внутренняя ошибка при создании объекта обработчика - '"));					// 60
	AoM.Add(NStr("ru=''"));		// 61
	AoM.Add(NStr("ru=''"));		// 62
	AoM.Add(NStr("ru='Ошибка создания COMobject обработчика %Processor% для устройства {%DeviceID%}:'")); // 63
	AoM.Add(NStr("ru='Тип обработчика = %Type% не поддерживается данной версией менеджера'"));		// 64
	AoM.Add(NStr("ru='Ошибка первоначальной инициализации объекта обработчика устройства'"));		// 65
	AoM.Add(NStr("ru='Ошибка инициализации обработчика устройства {%DeviceID%} - '"));				// 66
	AoM.Add(NStr("ru='Ошибка при передаче настроек в устройство {%DeviceID%} - '"));				// 67
	AoM.Add(NStr("ru='Ошибка при передаче настроек в устройство {%DeviceID%} - '"));				// 68
	AoM.Add(NStr("ru='Ошибка при инициализации объекта обработчика устройства {%DeviceID%} - '"));	// 69
	AoM.Add(NStr("ru='Устройство находится в состоянии ""ВЫКЛЮЧЕНО"".
	                 |Перед началом использования его необходимо включить (Выполнить команду ""Enable"")'")); // 70
	AoM.Add(NStr("ru='Устройство занято. В настоящий момент исполняется команда ""%CommandName%""'")); // 71
	AoM.Add(NStr("ru='Устройство заблокировано из другой сессии: %OwnerName%'"));					// 72
	AoM.Add(NStr("ru=''"));		// 73
	AoM.Add(NStr("ru=''"));		// 74
	AoM.Add(NStr("ru=''"));		// 75
	AoM.Add(NStr("ru='Ошибка: метод ""%CommandName%"" обработчика устройства {%DeviceID%} вернул не булев результат'")); // 76
	AoM.Add(NStr("ru='Ошибка при вызове команды ""%CommandName%"" у обработчика устройства {%DeviceID%}")); // 77
	AoM.Add(NStr("ru='Ошибка: метод ""%CommandName%"" обработчика устройства {%DeviceID%}" + Символы.ПС
	               + "вернул отрицательный результат. Описание ошибки отсутствует")); // 78
	AoM.Add(NStr("ru='Внутренняя ошибка менеджера внешнего оборудования при исполнении метода ExecuteCommand'")); // 79
	AoM.Add(NStr("ru='Ошибка инициализации компоненты сетевого транспорта'"));						// 80
	AoM.Add(NStr("ru='Сетевой режим работы не доступен'"));											// 81
	AoM.Add(NStr("ru=''"));		// 82
	AoM.Add(NStr("ru=''"));		// 83
	AoM.Add(NStr("ru=''"));		// 84
	AoM.Add(NStr("ru=''"));		// 85
	AoM.Add(NStr("ru=''"));		// 86
	AoM.Add(NStr("ru=''"));		// 87
	AoM.Add(NStr("ru=''"));		// 88
	AoM.Add(NStr("ru=''"));		// 89
	AoM.Add(NStr("ru=''"));		// 91
	AoM.Add(NStr("ru=''"));		// 92
	AoM.Add(NStr("ru=''"));		// 93
	AoM.Add(NStr("ru=''"));		// 94
	AoM.Add(NStr("ru=''"));		// 95
	AoM.Add(NStr("ru=''"));		// 96
	AoM.Add(NStr("ru=''"));		// 97
	AoM.Add(NStr("ru=''"));		// 98
	AoM.Add(NStr("ru='Запрошенный функционал не поддерживается текущим вариантом реализации менеджера'")); // 99
	AoM.Add(NStr("ru=''"));		// 100

	Return AoM;

EndFunction

#КонецОбласти