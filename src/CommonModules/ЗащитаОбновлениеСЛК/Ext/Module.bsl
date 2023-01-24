
#Область СлужебныйПрограммныйИнтерфейс  

// Получить прокси веб-сервиса
//
Функция ПолучитьWSПроксиRemoteAccessService() Экспорт
	
	ПараметрыПодключения = ПолучитьПараметрыПодключенияRemoteAccessService();
	Определение          = Новый WSОпределения(ПараметрыПодключения.WebServiceURL,ПараметрыПодключения.Username,ПараметрыПодключения.Password);
	// Создаем прокси для обращения к внешнему веб-сервису, передаем в функцию URI пространства имен, имя сервиса и порта.
	Прокси               = Новый WSПрокси(Определение,ПараметрыПодключения.NamespaceWebService, ПараметрыПодключения.WebServiceName, ПараметрыПодключения.WebServicePort);	
	Прокси.Пользователь  = ПараметрыПодключения.Username;
	Прокси.Пароль        = ПараметрыПодключения.Password;	
	Возврат Прокси;
	
КонецФункции

// Функция вернет пакет параметров необходимых для
// взаимодействия с веб-сервисом регистрации RemoteAccessService
Функция ПолучитьПараметрыПодключенияRemoteAccessService()
	
	ПарамтерыПодключения = Новый Структура;
	ПарамтерыПодключения.Вставить("WebServiceURL"          ,"http://95.163.137.45/taskman/ws/x_RemoteAccessService?wsdl");
	ПарамтерыПодключения.Вставить("WebServiceName"         ,"x_RemoteAccessService");
	ПарамтерыПодключения.Вставить("WebServicePort"         ,"x_RemoteAccessServiceSoap");
	ПарамтерыПодключения.Вставить("NamespaceWebService"    ,"http://TaskMan/WebService");
	ПарамтерыПодключения.Вставить("NamespaceXDTOWorksheet" ,"http://TaskMan/WebService/Worksheet");
	ПарамтерыПодключения.Вставить("NamespaceXDTOUpdate"    ,"http://TaskMan/WebService/UpdateConfiguration");
	ПарамтерыПодключения.Вставить("Username"               ,"wsdl");
    ПарамтерыПодключения.Вставить("Password"               ,"wsdl");
	Возврат ПарамтерыПодключения;
	
КонецФункции

#КонецОбласти
