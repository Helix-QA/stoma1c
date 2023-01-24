
#Область СлужебныеПроцедурыИФункции

Функция XSLT_Структура() Экспорт 
	
	СтрокаXSD = ("
	//|<?xml version=""1.0"" encoding=""utf-16""?>
	|<xs:schema xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" attributeFormDefault=""unqualified"" elementFormDefault=""qualified"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"">
	|  <xs:element name=""eDIMessage"">
	|    <xs:complexType mixed=""true"">
	|      <xs:sequence>
	|        <xs:element name=""interchangeHeader"">
	|          <xs:complexType>
	|            <xs:sequence>
	|              <xs:element name=""sender"" type=""xs:string"" />
	|              <xs:element name=""recipient"" type=""xs:string"" />
	|              <xs:element name=""documentType"" type=""xs:string"" />
	|            </xs:sequence>
	|          </xs:complexType>
	|        </xs:element>
	|        <xs:element name=""insurantsList"">
	|          <xs:complexType mixed=""true"">
	|            <xs:sequence>
	|              <xs:element name=""insurantsListFunction"" type=""xs:string"" />
	|              <xs:element name=""contractIdentificator"">
	|                <xs:complexType>
	|                  <xs:attribute name=""date"" type=""xs:date"" use=""required"" />
	|                  <xs:attribute name=""number"" type=""xs:string"" use=""required"" />
	|                </xs:complexType>
	|              </xs:element>
	|              <xs:element name=""insuranceCompany"">
	|                <xs:complexType mixed=""true"">
	|                  <xs:sequence>
	|                    <xs:element name=""mediId"" type=""xs:unsignedInt"" />
	|                    <xs:element name=""organization"">
	|                      <xs:complexType>
	|                        <xs:sequence>
	|                          <xs:element name=""name"" type=""xs:string"" />
	|                          <xs:element name=""inn"" type=""xs:unsignedInt"" />
	|                          <xs:element name=""kpp"" type=""xs:unsignedInt"" />
	|                        </xs:sequence>
	|                      </xs:complexType>
	|                    </xs:element>
	|                  </xs:sequence>
	|                </xs:complexType>
	|              </xs:element>
	|              <xs:element name=""healthCareProvider"">
	|                <xs:complexType mixed=""true"">
	|                  <xs:sequence>
	|                    <xs:element name=""mediId"" type=""xs:unsignedInt"" />
	|                    <xs:element name=""organization"">
	|                      <xs:complexType>
	|                        <xs:sequence>
	|                          <xs:element name=""name"" type=""xs:string"" />
	|                          <xs:element name=""inn"" type=""xs:unsignedInt"" />
	|                          <xs:element name=""kpp"" type=""xs:unsignedInt"" />
	|                        </xs:sequence>
	|                      </xs:complexType>
	|                    </xs:element>
	|                  </xs:sequence>
	|                </xs:complexType>
	|              </xs:element>
	|              <xs:element name=""insuranceCompanyDepartment"">
	|                <xs:complexType mixed=""true"">
	|                  <xs:sequence>
	|                    <xs:element name=""mediId"" type=""xs:unsignedInt"" />
	|                    <xs:element name=""organization"">
	|                      <xs:complexType>
	|                        <xs:sequence>
	|                          <xs:element name=""name"" type=""xs:string"" />
	|                          <xs:element name=""inn"" type=""xs:unsignedInt"" />
	|                          <xs:element name=""kpp"" type=""xs:unsignedInt"" />
	|                        </xs:sequence>
	|                      </xs:complexType>
	|                    </xs:element>
	|                  </xs:sequence>
	|                </xs:complexType>
	|              </xs:element>
	|              <xs:element name=""healthCareProviderDepartment"">
	|                <xs:complexType mixed=""true"">
	|                  <xs:sequence>
	|                    <xs:element name=""mediId"" type=""xs:unsignedLong"" />
	|                    <xs:element name=""organization"">
	|                      <xs:complexType>
	|                        <xs:sequence>
	|                          <xs:element name=""name"" type=""xs:string"" />
	|                          <xs:element name=""inn"" type=""xs:unsignedInt"" />
	|                          <xs:element name=""kpp"" type=""xs:unsignedInt"" />
	|                        </xs:sequence>
	|                      </xs:complexType>
	|                    </xs:element>
	|                  </xs:sequence>
	|                </xs:complexType>
	|              </xs:element>
	|              <xs:element name=""listOfInsurants"">
	|                <xs:complexType mixed=""true"">
	|                  <xs:sequence>
	|                    <xs:element maxOccurs=""unbounded"" name=""insurant"">
	|                      <xs:complexType mixed=""true"">
	|                        <xs:sequence>
	|                          <xs:element minOccurs=""0"" name=""old_info"" type=""xs:string"" />
	|                          <xs:element name=""fullName"">
	|                            <xs:complexType>
	|                              <xs:sequence>
	|                                <xs:element name=""lastName"" type=""xs:string"" />
	|                                <xs:element name=""firstName"" type=""xs:string"" />
	|                                <xs:element name=""middleName"" type=""xs:string"" />
	|                              </xs:sequence>
	|                            </xs:complexType>
	|                          </xs:element>
	|                          <xs:element name=""dateOfBirth"" type=""xs:date"" />
	|                          <xs:element name=""gender"" type=""xs:string"" />
	|                          <xs:element minOccurs=""0"" name=""insuredPersonStatus"" type=""xs:string"" />
	|                          <xs:element name=""employer"">
	|                            <xs:complexType mixed=""true"">
	|                              <xs:sequence>
	|                                <xs:element name=""mediId"" type=""xs:unsignedLong"" />
	|                                <xs:element name=""organization"">
	|                                  <xs:complexType>
	|                                    <xs:sequence>
	|                                      <xs:element name=""name"" type=""xs:string"" />
	|                                      <xs:element name=""inn"" type=""xs:unsignedInt"" />
	|                                      <xs:element name=""kpp"" type=""xs:unsignedInt"" />
	|                                    </xs:sequence>
	|                                  </xs:complexType>
	|                                </xs:element>
	|                                <xs:element name=""russianAddress"">
	|                                  <xs:complexType>
	|                                    <xs:sequence>
	|                                      <xs:element name=""postalCode"" type=""xs:unsignedInt"" />
	|                                      <xs:element name=""regionISOCode"" type=""xs:string"" />
	|                                      <xs:element name=""district"" type=""xs:string"" />
	|                                      <xs:element name=""city"" type=""xs:string"" />
	|                                      <xs:element name=""settlement"" type=""xs:string"" />
	|                                      <xs:element name=""street"" type=""xs:string"" />
	|                                      <xs:element name=""house"" type=""xs:unsignedByte"" />
	|                                      <xs:element name=""building"" type=""xs:unsignedByte"" />
	|                                      <xs:element name=""office"" type=""xs:unsignedByte"" />
	|                                    </xs:sequence>
	|                                  </xs:complexType>
	|                                </xs:element>
	|                              </xs:sequence>
	|                            </xs:complexType>
	|                          </xs:element>
	|                          <xs:element name=""insurancePolicy"">
	|                            <xs:complexType>
	|                              <xs:sequence>
	|                                <xs:element name=""number"" type=""xs:string"" />
	|                                <xs:element name=""fromDate"" type=""xs:date"" />
	|                                <xs:element name=""toDate"" type=""xs:date"" />
	|                                <xs:element minOccurs=""0"" name=""bindingEndDate"" type=""xs:date"" />
	|                              </xs:sequence>
	|                            </xs:complexType>
	|                          </xs:element>
	|                          <xs:element name=""insuranceProgram"">
	|                            <xs:complexType>
	|                              <xs:sequence>
	|                                <xs:element name=""name"" type=""xs:string"" />
	|                                <xs:element name=""code"" type=""xs:string"" />
	|                                <xs:element name=""comment"" type=""xs:string"" />
	|                                <xs:element minOccurs=""0"" name=""programLocationCode"" type=""xs:string"" />
	|                                <xs:element name=""contractIdentificator"">
	|                                  <xs:complexType>
	|                                    <xs:attribute name=""date"" type=""xs:date"" use=""required"" />
	|                                    <xs:attribute name=""number"" type=""xs:string"" use=""required"" />
	|                                  </xs:complexType>
	|                                </xs:element>
	|                                <xs:element minOccurs=""0"" name=""paymentOptions"" type=""xs:string"" />
	|                                <xs:element minOccurs=""0"" name=""supplementaryAgreementIdentificator"">
	|                                  <xs:complexType>
	|                                    <xs:attribute name=""date"" type=""xs:date"" use=""required"" />
	|                                    <xs:attribute name=""number"" type=""xs:string"" use=""required"" />
	|                                  </xs:complexType>
	|                                </xs:element>
	|                              </xs:sequence>
	|                            </xs:complexType>
	|                          </xs:element>
	|                          <xs:element name=""contacts"">
	|                            <xs:complexType>
	|                              <xs:sequence>
	|                                <xs:element name=""cellPhone"" type=""xs:unsignedInt"" />
	|                                <xs:element name=""homePhone"" type=""xs:unsignedInt"" />
	|                                <xs:element name=""privateEmail"" type=""xs:string"" />
	|                              </xs:sequence>
	|                            </xs:complexType>
	|                          </xs:element>
	|                          <xs:element name=""identificationDocument"">
	|                            <xs:complexType>
	|                              <xs:sequence>
	|                                <xs:element name=""number"" type=""xs:unsignedInt"" />
	|                                <xs:element name=""series"" type=""xs:unsignedShort"" />
	|                                <xs:element name=""category"" type=""xs:string"" />
	|                                <xs:element name=""issued"" type=""xs:date"" />
	|                                <xs:element name=""issuedBy"" type=""xs:string"" />
	|                                <xs:element name=""identificationDocumentType"" type=""xs:string"" />
	|                              </xs:sequence>
	|                            </xs:complexType>
	|                          </xs:element>
	|                          <xs:element name=""russianAddress"">
	|                            <xs:complexType>
	|                              <xs:sequence>
	|                                <xs:element minOccurs=""0"" name=""fullAddress"" type=""xs:string"" />
	|                                <xs:element name=""postalCode"" type=""xs:unsignedInt"" />
	|                                <xs:element name=""regionISOCode"" type=""xs:string"" />
	|                                <xs:element name=""district"" type=""xs:string"" />
	|                                <xs:element name=""city"" type=""xs:string"" />
	|                                <xs:element name=""settlement"" type=""xs:string"" />
	|                                <xs:element name=""street"" type=""xs:string"" />
	|                                <xs:element name=""house"" type=""xs:unsignedByte"" />
	|                                <xs:element name=""building"" type=""xs:unsignedByte"" />
	|                                <xs:element name=""office"" type=""xs:unsignedByte"" />
	|                              </xs:sequence>
	|                            </xs:complexType>
	|                          </xs:element>
	|                        </xs:sequence>
	|                      </xs:complexType>
	|                    </xs:element>
	|                  </xs:sequence>
	|                </xs:complexType>
	|              </xs:element>
	|            </xs:sequence>
	|            <xs:attribute name=""insurantsListDate"" type=""xs:date"" use=""required"" />
	|            <xs:attribute name=""insurantsListNumber"" type=""xs:string"" use=""required"" />
	|          </xs:complexType>
	|        </xs:element>
	|      </xs:sequence>
	|      <xs:attribute name=""id"" type=""xs:string"" use=""required"" />
	|    </xs:complexType>
	|  </xs:element>
	|</xs:schema>
	|");
	Возврат СтрокаXSD;   
	
КонецФункции

Функция ПоследнееПисьмо() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СообщенияКонтурСтрахование.lastEventPointer КАК lastEventPointer,
		|	СообщенияКонтурСтрахование.contentType КАК contentType
		|ИЗ
		|	РегистрСведений.СообщенияКонтурСтрахование КАК СообщенияКонтурСтрахование
		|ГДЕ
		|	СообщенияКонтурСтрахование.contentType <> ""NewInboxMessageEventContent""
		|
		|УПОРЯДОЧИТЬ ПО
		|	СообщенияКонтурСтрахование.eventDateTime УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.lastEventPointer;
	Иначе
		Возврат "";
	КонецЕсли;
		
КонецФункции

Процедура ПолучитьСписокСобытийНаСервере(Результат) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	lastEventPointer = Результат.Получить("lastEventPointer");
	
	Для Каждого Событие Из Результат.Получить("events") Цикл
		
		МенеджерЗаписи = РегистрыСведений.СообщенияКонтурСтрахование.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.mediId			= Событие.Получить("mediId");
		МенеджерЗаписи.eventId			= Событие.Получить("eventId");
		МенеджерЗаписи.eventPointer		= Событие.Получить("eventPointer");
		МенеджерЗаписи.eventDateTime	= Событие.Получить("eventDateTime");
		МенеджерЗаписи.eventType		= Событие.Получить("eventType");
		
		МенеджерЗаписи.lastEventPointer = lastEventPointer;
		
		Если Не ЗначениеЗаполнено(МенеджерЗаписи.eventDateTime) Тогда
			МенеджерЗаписи.eventDateTime = Строка(ТекущаяДатаСеанса());	
		КонецЕсли;
			
		Если МенеджерЗаписи.eventType = "NewOutboxMessage" Тогда
			
			// NewOutboxMessageEventContent
			
			eventContent = Событие.Получить("eventContent");
			
			МенеджерЗаписи.contentType = eventContent.Получить("contentType");
			
			Мета = eventContent.Получить("basicMessageMeta");
			
			МенеджерЗаписи.messageId				= Мета.Получить("messageId");
			МенеджерЗаписи.documentCirculationId	= Мета.Получить("documentCirculationId");
			
		ИначеЕсли МенеджерЗаписи.eventType = "NewInboxMessage" Тогда
			
			// NewInboxMessageEventContent
			
			eventContent = Событие.Получить("eventContent");
			
			МенеджерЗаписи.contentType = eventContent.Получить("contentType");
			Мета = eventContent.Получить("fullMessageMeta");
			
			МенеджерЗаписи.messageId				= Мета.Получить("messageId");
			МенеджерЗаписи.documentCirculationId	= Мета.Получить("documentCirculationId");
			
			documentDetails = Мета.Получить("documentDetails");
			
			МенеджерЗаписи.documentType	= documentDetails.Получить("documentType");
			МенеджерЗаписи.documentNumber	= documentDetails.Получить("documentNumber");
			МенеджерЗаписи.documentDate	= documentDetails.Получить("documentDate");
			
			route = Мета.Получить("route");
			
			МенеджерЗаписи.senderMediId	= route.Получить("senderMediId");
			МенеджерЗаписи.recipientMediId	= route.Получить("recipientMediId");
			
			
		ИначеЕсли МенеджерЗаписи.eventType	= "MessageDelivered" Тогда
			
			// MessageDeliveredEventContent
			
			eventContent = Событие.Получить("eventContent");
			
			МенеджерЗаписи.contentType = eventContent.Получить("contentType");
			Мета = eventContent.Получить("fullMessageMeta");
			
			МенеджерЗаписи.messageId				= Мета.Получить("messageId");
			МенеджерЗаписи.documentCirculationId	= Мета.Получить("documentCirculationId");
			
			documentDetails = Мета.Получить("documentDetails");
			
			МенеджерЗаписи.documentType	= documentDetails.Получить("documentType");
			МенеджерЗаписи.documentNumber	= documentDetails.Получить("documentNumber");
			МенеджерЗаписи.documentDate	= documentDetails.Получить("documentDate");
			
			route = Мета.Получить("route");
			
			МенеджерЗаписи.senderMediId	= route.Получить("senderMediId");
			МенеджерЗаписи.recipientMediId	= route.Получить("recipientMediId");
			
		ИначеЕсли МенеджерЗаписи.eventType = "ProcessingTimesReport" Тогда	
			
			// ProcessingTimesEventContent
			
			eventContent = Событие.Получить("eventContent");
			МенеджерЗаписи.contentType = eventContent.Получить("contentType");
			
			МенеджерЗаписи.documentCirculationId	= eventContent.Получить("documentCirculationId");
			МенеджерЗаписи.documentCirculationStartTimestamp	= eventContent.Получить("documentCirculationStartTimestamp");
			МенеджерЗаписи.documentCirculationCompletionTimestamp	= eventContent.Получить("documentCirculationCompletionTimestamp");
			
			processingTimes = eventContent.Получить("processingTimes");
			
			МенеджерЗаписи.totalWorkTime = processingTimes.Получить("totalWorkTime");
			МенеджерЗаписи.deliveryTime = processingTimes.Получить("deliveryTime");
			
		ИначеЕсли МенеджерЗаписи.eventType	= "MessageUndelivered" Тогда
			
			// MessageUndeliveredEventContent
			
			eventContent = Событие.Получить("eventContent");
			
			МенеджерЗаписи.contentType = eventContent.Получить("contentType");
			Мета = eventContent.Получить("basicMessageMeta");
			
			МенеджерЗаписи.messageId				= Мета.Получить("messageId");
			МенеджерЗаписи.documentCirculationId	= Мета.Получить("documentCirculationId");
			
			documentDetails = Мета.Получить("documentDetails");
			
			Причины = eventContent.Получить("reasons");
			
			СтрокаПричин = "";
			Для Каждого Эл Из Причины Цикл
				СтрокаПричин = СтрокаПричин+Эл+Символы.ПС;
			КонецЦикла;
			
			МенеджерЗаписи.reasons = СтрокаПричин;
			
		ИначеЕсли МенеджерЗаписи.eventType	= "MessageCheckedByRecipient" Тогда
			
			// MessageCheckedByRecipient
			
			eventContent = Событие.Получить("eventContent");
			
			МенеджерЗаписи.messageId = eventContent.Получить("messageId");
			МенеджерЗаписи.documentCirculationId = eventContent.Получить("documentCirculationId");
			МенеджерЗаписи.checkingStatus = eventContent.Получить("checkingStatus");
			МенеджерЗаписи.description = eventContent.Получить("description");
			МенеджерЗаписи.contentType = eventContent.Получить("contentType");
			
			route = eventContent.Получить("route");
			
			МенеджерЗаписи.senderMediId	= route.Получить("senderMediId");
			МенеджерЗаписи.recipientMediId	= route.Получить("recipientMediId");
			
		КонецЕсли; 

		СообщениеСуществует = ПроверитьСообщение(МенеджерЗаписи.messageId, МенеджерЗаписи.eventType, МенеджерЗаписи.description, МенеджерЗаписи.reasons);
		Если СообщениеСуществует Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			МенеджерЗаписи.Записать(Истина);
		Исключение	
			
		КонецПопытки;
		
	КонецЦикла;

	ОбработатьСообщенияКонтурСтрахование();
	
КонецПроцедуры

Процедура ОбработатьСообщенияКонтурСтрахование() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СообщенияКонтурСтрахование.messageId КАК messageId,
	|	СообщенияКонтурСтрахование.mediId КАК mediId,
	|	СообщенияКонтурСтрахование.eventId КАК eventId,
	|	СообщенияКонтурСтрахование.eventPointer КАК eventPointer,
	|	СообщенияКонтурСтрахование.eventDateTime КАК eventDateTime,
	|	СообщенияКонтурСтрахование.eventType КАК eventType,
	|	СообщенияКонтурСтрахование.documentType КАК documentType
	|ИЗ
	|	РегистрСведений.СообщенияКонтурСтрахование КАК СообщенияКонтурСтрахование
	|ГДЕ
	|	СообщенияКонтурСтрахование.documentType = ""Relist""
	|	И СообщенияКонтурСтрахование.checkingStatus <> ""Ok""";
	
	Результат = Запрос.Выполнить().Выбрать();
	
	ВнешняяСистемаКС = Справочники.ВнешниеСистемы.ПолучитьВнешнююСистему(,Перечисления.ТипыВнешнихСистем.КонтурСтрахование, Истина);
	token = ВнешняяСистемаКС.ТокенДоступа;
	
	ПараметрыВС = ВнешняяСистемаКС.Параметры.Получить();
	
	Если ПараметрыВС.Демо Тогда
		АдресСервера = "medi-api.testkontur.ru";	
	Иначе
		АдресСервера = "medi-api.kontur.ru";	
	КонецЕсли;
	
	Пока Результат.Следующий() Цикл
		
		Запрос = Новый HTTPЗапрос("/V2/messages/{messageId}");
		Запрос.Заголовки.Вставить("Authorization", "Bearer "+ token);
		
		URL_УстановитьПараметр(Запрос.АдресРесурса, "messageId", Результат.messageId);
		
		Ответ = ВыполнитьHTTPМетодСервер("GET", Запрос, АдресСервера);
		
		Если Ответ.КодСостояния = 404 Тогда
			ЗаписьЖурналаРегистрации("Сообщение не найдено: ", УровеньЖурналаРегистрации.Ошибка,,, Ответ.ПолучитьТелоКакСтроку());
		ИначеЕсли Ответ.КодСостояния = 401 Тогда
			ЗаписьЖурналаРегистрации("Запрос не авторизован: ", УровеньЖурналаРегистрации.Ошибка,,, Ответ.ПолучитьТелоКакСтроку());
		ИначеЕсли Ответ.КодСостояния = 400 Тогда
			ЗаписьЖурналаРегистрации("Некорректный формат идентификатора сообщения: ", УровеньЖурналаРегистрации.Ошибка,,, Ответ.ПолучитьТелоКакСтроку());
		ИначеЕсли Ответ.КодСостояния >= 300 Тогда
			ЗаписьЖурналаРегистрации("Не удалось выполнить запрос: ", УровеньЖурналаРегистрации.Ошибка,,, Ответ.ПолучитьТелоКакСтроку());
		ИначеЕсли Ответ.КодСостояния = 200 Тогда	
			
			Сообщение = JSON_Прочитать(Ответ.ПолучитьТелоКакСтроку());
			
			РезультатЗаполнения = ЗаписатьДанныеПолисов(Сообщение);
			
			Попытка
				
				НаборЗаписей = РегистрыСведений.СообщенияКонтурСтрахование.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.mediId.Установить(Результат.mediId);
				НаборЗаписей.Отбор.eventId.Установить(Результат.eventId);
				НаборЗаписей.Отбор.eventPointer.Установить(Результат.eventPointer);
				НаборЗаписей.Отбор.eventDateTime.Установить(Результат.eventDateTime);
				НаборЗаписей.Отбор.eventType.Установить(Результат.eventType);  
				НаборЗаписей.Прочитать();
				
				Для Каждого Запись Из НаборЗаписей Цикл
					Если РезультатЗаполнения = 200 Тогда
						Запись.checkingStatus   = "Ok"; 
						Ошибка = "";
					Иначе
						Запись.checkingStatus   = "Fail";
						Запись.description		= РезультатЗаполнения;
						Ошибка = РезультатЗаполнения;						
					КонецЕсли;
				КонецЦикла;	
				
				НаборЗаписей.Записать();
			Исключение	
				
			КонецПопытки;
			
			РезультатОбраотки = SetMessageStatus(Результат.messageId, Запись.checkingStatus, Ошибка);
			
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВыполнитьHTTPМетодСервер(Метод, Запрос, Хост)
	
	Возврат СоединениеСервер(Хост).ВызватьHTTPМетод(Метод, Запрос);
	
КонецФункции

Функция СоединениеСервер(Хост)
	
	Порт = 443;
	
	Соединение = Новый HTTPСоединение(Хост, Порт,,,,,Новый ЗащищенноеСоединениеOpenSSL);
	
	Возврат Соединение;
	
КонецФункции

Функция ЗаписатьДанныеПолисов(Сообщение);
	
	ТаблицаЗастрахованных = Новый ТаблицаЗначений;
	ТаблицаЗастрахованных.Колонки.Добавить("Фамилия");
	ТаблицаЗастрахованных.Колонки.Добавить("Имя");
	ТаблицаЗастрахованных.Колонки.Добавить("Отчество");
	ТаблицаЗастрахованных.Колонки.Добавить("ДатаРождения", Новый ОписаниеТипов("Дата"));
	ТаблицаЗастрахованных.Колонки.Добавить("Пол", Новый ОписаниеТипов("ПеречислениеСсылка.ПолФизическогоЛица"));
	ТаблицаЗастрахованных.Колонки.Добавить("НомерПолиса"); 
	ТаблицаЗастрахованных.Колонки.Добавить("ДействуетС", Новый ОписаниеТипов("Дата"));
	ТаблицаЗастрахованных.Колонки.Добавить("ДействуетПо", Новый ОписаниеТипов("Дата"));
	ТаблицаЗастрахованных.Колонки.Добавить("ОткрепленС", Новый ОписаниеТипов("Дата"));
	ТаблицаЗастрахованных.Колонки.Добавить("Страхователь");
	ТаблицаЗастрахованных.Колонки.Добавить("ПрограммаПрикрепления"); 
	ТаблицаЗастрахованных.Колонки.Добавить("Адрес", Новый ОписаниеТипов("Структура"));
	ТаблицаЗастрахованных.Колонки.Добавить("Дубль", Новый ОписаниеТипов("Булево"));
	ТаблицаЗастрахованных.Колонки.Добавить("ДомашнийТелефон");
	ТаблицаЗастрахованных.Колонки.Добавить("МобильныйТелефон");
	ТаблицаЗастрахованных.Колонки.Добавить("ЭлПочта");
	
	Если ТипЗнч(Сообщение) = Тип("Соответствие") Тогда
		
		ДвоичныеДанные = Base64Значение(Сообщение.Получить("data").Получить("content"));
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		
		//ЗапуститьПриложение(ИмяВременногоФайла);  
		
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ИмяВременногоФайла);
		
		ПостроительDOM = Новый ПостроительDOM;
		ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
		
		Для Каждого Глубина1 Из ДокументDOM.ЭлементДокумента.ДочерниеУзлы Цикл
			
			Отправитель 			="";
			Получатель              ="";
			НомерСписка             ="";
			ДатаСписка              =Дата(1,1,1);
			НомерДоговора           ="";
			ДатаДоговора	        =Дата(1,1,1);
			mediId                  ="";
			НаименованиеСК          ="";
			ИНН                     ="";
			КПП                     ="";
			mediIdОрганизации       ="";
			НаименованиеОрганизации ="";
			ИННОрганизации          ="";
			КППОрганизации          ="";
			
			Если Глубина1.ИмяУзла = "interchangeHeader" Тогда
				Для Каждого Глубина2 Из Глубина1.ДочерниеУзлы Цикл
					Если Глубина2.ИмяУзла = "sender" Тогда
						Отправитель = Глубина2.ТекстовоеСодержимое;
					ИначеЕсли Глубина2.ИмяУзла = "recipient" Тогда
						Получатель = Глубина2.ТекстовоеСодержимое;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если Глубина1.ИмяУзла = "insurantsList" Тогда
				
				Для Каждого Глубина2 Из Глубина1.Атрибуты Цикл
					Если Глубина2.ИмяУзла = "insurantsListNumber" Тогда     
						НомерСписка = Глубина2.ЗначениеУзла;
					ИначеЕсли Глубина2.ИмяУзла = "insurantsListDate" Тогда 
						Если СтрНайти(Глубина2.ЗначениеУзла, "-") > 0 Тогда
							ДатаСписка = Дата(СтрЗаменить(Глубина2.ЗначениеУзла, "-", ""));
						Иначе
							ДатаСписка = Дата('00010101');
							ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВДату(ДатаСписка, Глубина2.ЗначениеУзла);
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;   
				
				Для Каждого Глубина2 Из Глубина1.ДочерниеУзлы Цикл
					// 1 - Прикрепление 2 - Открепление 3 - Изменение ПДн
					ТипСообщения = 1;
					Если Глубина2.ИмяУзла = "insurantsListFunction" Тогда
						Если Глубина2.ТекстовоеСодержимое = "Deletion" Тогда
							ТипСообщения = 2;
						ИначеЕсли 
							Глубина2.ТекстовоеСодержимое = "PersonalInfoChange" Тогда
								ТипСообщения = 3;
						КонецЕсли;
					КонецЕсли;
					
					Если Глубина2.ИмяУзла = "contractIdentificator" Тогда
						Для Каждого Глубина3 Из Глубина2.Атрибуты Цикл
							Если Глубина3.ИмяУзла = "number" Тогда     
								НомерДоговора = Глубина3.ЗначениеУзла;
							ИначеЕсли Глубина3.ИмяУзла = "date" Тогда 
								Если СтрНайти(Глубина3.ЗначениеУзла, "-") > 0 Тогда
									ДатаДоговора = Дата(СтрЗаменить(Глубина3.ЗначениеУзла, "-", ""));
								Иначе
									ДатаДоговора = Дата('00010101');
									ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВДату(ДатаДоговора, Глубина3.ЗначениеУзла);
								КонецЕсли;
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
					
					Если Глубина2.ИмяУзла = "insuranceCompany" Тогда     
						Для Каждого Глубина3 Из Глубина2.ДочерниеУзлы Цикл
							Если Глубина3.ИмяУзла = "mediId" Тогда	
								mediId = Глубина3.ТекстовоеСодержимое;                 
							ИначеЕсли Глубина3.ИмяУзла = "organization" Тогда
								Для Каждого Глубина4 Из Глубина3.ДочерниеУзлы Цикл
									Если Глубина4.ИмяУзла = "name" Тогда     
										НаименованиеСК = Глубина4.ТекстовоеСодержимое;
									ИначеЕсли Глубина4.ИмяУзла = "inn" Тогда 
										ИНН = Глубина4.ТекстовоеСодержимое;
									ИначеЕсли Глубина4.ИмяУзла = "kpp" Тогда 
										КПП = Глубина4.ТекстовоеСодержимое;
									КонецЕсли;	
								КонецЦикла;
							КонецЕсли;
						КонецЦикла;
					ИначеЕсли Глубина2.ИмяУзла = "healthCareProvider" Тогда 
						Для Каждого Глубина3 Из Глубина2.ДочерниеУзлы Цикл
							Если Глубина3.ИмяУзла = "mediId" Тогда	
								mediIdОрганизации = Глубина3.ТекстовоеСодержимое;                 
							ИначеЕсли Глубина3.ИмяУзла = "organization" Тогда
								Для Каждого Глубина4 Из Глубина3.ДочерниеУзлы Цикл
									Если Глубина4.ИмяУзла = "name" Тогда     
										НаименованиеОрганизации = Глубина4.ТекстовоеСодержимое;
									ИначеЕсли Глубина4.ИмяУзла = "inn" Тогда 
										ИННОрганизации = Глубина4.ТекстовоеСодержимое;
									ИначеЕсли Глубина4.ИмяУзла = "kpp" Тогда 
										КППОрганизации = Глубина4.ТекстовоеСодержимое;
									КонецЕсли;	
								КонецЦикла;
							КонецЕсли;
						КонецЦикла;
					ИначеЕсли Глубина2.ИмяУзла = "listOfInsurants" Тогда
						Для Каждого Глубина3 Из Глубина2.ДочерниеУзлы Цикл	
							Если Глубина3.ИмяУзла = "insurant" Тогда 
								НоваяСтрока = ТаблицаЗастрахованных.Добавить();
								НоваяСтрока.Адрес = РаботаСАдресамиКлиентСервер.ОписаниеНовойКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
								Для Каждого Глубина4 Из Глубина3.ДочерниеУзлы Цикл
									Если Глубина4.ИмяУзла = "insuredPersonStatus" Тогда
										Если Глубина4.ТекстовоеСодержимое = "Original" Тогда
											НоваяСтрока.Дубль = Ложь;	
										Иначе
											НоваяСтрока.Дубль = Истина;
										КонецЕсли;
									ИначеЕсли Глубина4.ИмяУзла = "fullName" Тогда
										Для Каждого Глубина5 Из Глубина4.ДочерниеУзлы Цикл
											Если Глубина5.ИмяУзла = "lastName" Тогда
												НоваяСтрока.Фамилия = ТРег(Глубина5.ТекстовоеСодержимое);	
											ИначеЕсли Глубина5.ИмяУзла = "firstName" Тогда
												НоваяСтрока.Имя = ТРег(Глубина5.ТекстовоеСодержимое);		
											ИначеЕсли Глубина5.ИмяУзла = "middleName" Тогда
												НоваяСтрока.Отчество = ТРег(Глубина5.ТекстовоеСодержимое);	
											КонецЕсли;
										КонецЦикла;
									ИначеЕсли Глубина4.ИмяУзла = "dateOfBirth" Тогда
										НоваяСтрока.ДатаРождения = Дата(СтрЗаменить(Глубина4.ТекстовоеСодержимое, "-", ""));				
									ИначеЕсли Глубина4.ИмяУзла = "gender" Тогда     
										Если Глубина4.ТекстовоеСодержимое = "Female" Тогда
											НоваяСтрока.Пол = Перечисления.ПолФизическогоЛица.Женский;	
										ИначеЕсли Глубина4.ТекстовоеСодержимое = "Male" Тогда
											НоваяСтрока.Пол = Перечисления.ПолФизическогоЛица.Мужской;	
										КонецЕсли;
									ИначеЕсли Глубина4.ИмяУзла = "insurancePolicy" Тогда
										Для Каждого Глубина5 Из Глубина4.ДочерниеУзлы Цикл
											Если Глубина5.ИмяУзла = "number" Тогда
												НоваяСтрока.НомерПолиса = Глубина5.ТекстовоеСодержимое;	
											ИначеЕсли Глубина5.ИмяУзла = "fromDate" Тогда
												НоваяСтрока.ДействуетС = Дата(СтрЗаменить(Глубина5.ТекстовоеСодержимое, "-", ""));
											ИначеЕсли Глубина5.ИмяУзла = "toDate" Тогда
												НоваяСтрока.ДействуетПО = Дата(СтрЗаменить(Глубина5.ТекстовоеСодержимое, "-", "")); 
											ИначеЕсли Глубина5.ИмяУзла = "bindingEndDate" Тогда
												НоваяСтрока.ОткрепленС = Дата(СтрЗаменить(Глубина5.ТекстовоеСодержимое, "-", ""));
											КонецЕсли;	
										КонецЦикла;
									ИначеЕсли Глубина4.ИмяУзла = "employer" Тогда
										НоваяСтрока.Страхователь = Глубина4.ТекстовоеСодержимое;	
									ИначеЕсли Глубина4.ИмяУзла = "insuranceProgram" Тогда
										НоваяСтрока.ПрограммаПрикрепления = Глубина4.ТекстовоеСодержимое;
									ИначеЕсли Глубина4.ИмяУзла = "russianAddress" Тогда
										Для Каждого Глубина5 Из Глубина4.ДочерниеУзлы Цикл
											Если Глубина5.ИмяУзла = "fullAddress" Тогда
												НоваяСтрока.Адрес.value = Глубина5.ТекстовоеСодержимое;  
											ИначеЕсли Глубина5.ИмяУзла = "postalCode" Тогда
                                                НоваяСтрока.Адрес.ZIPcode = Глубина5.ТекстовоеСодержимое; 
										//	ИначеЕсли Глубина5.ИмяУзла = "regionISOCode" Тогда
                                                //НоваяСтрока.Адрес.value = Глубина5.ТекстовоеСодержимое; 
											ИначеЕсли Глубина5.ИмяУзла = "district" Тогда
                                                НоваяСтрока.Адрес.district = Глубина5.ТекстовоеСодержимое; 
											ИначеЕсли Глубина5.ИмяУзла = "city" Тогда
                                                НоваяСтрока.Адрес.city = Глубина5.ТекстовоеСодержимое;
											ИначеЕсли Глубина5.ИмяУзла = "settlement" Тогда
                                                НоваяСтрока.Адрес.settlement = Глубина5.ТекстовоеСодержимое;
											ИначеЕсли Глубина5.ИмяУзла = "street" Тогда
												НоваяСтрока.Адрес.street = Глубина5.ТекстовоеСодержимое;
											ИначеЕсли Глубина5.ИмяУзла = "house" Тогда
                                                НоваяСтрока.Адрес.houseNumber = Глубина5.ТекстовоеСодержимое;
											ИначеЕсли Глубина5.ИмяУзла = "building" Тогда
												ИнформацияОСтроении = Новый Структура("type, number", "Корпус", Глубина5.ТекстовоеСодержимое);
                                                НоваяСтрока.Адрес.Buildings.Добавить(ИнформацияОСтроении);
											ИначеЕсли Глубина5.ИмяУзла = "office" Тогда
												ИнформацияОПомещении = Новый Структура("type, number", "Квартира", Глубина5.ТекстовоеСодержимое);
    	                                        НоваяСтрока.Адрес.apartments.Добавить(ИнформацияОПомещении);
											КонецЕсли;
										КонецЦикла;
									ИначеЕсли Глубина4.ИмяУзла = "contacts" Тогда
										Для Каждого Глубина5 Из Глубина4.ДочерниеУзлы Цикл	
											Если Глубина5.ИмяУзла = "homePhone" Тогда
												НоваяСтрока.ДомашнийТелефон = Глубина5.ТекстовоеСодержимое;	
											ИначеЕсли Глубина5.ИмяУзла = "cellPhone" Тогда
												НоваяСтрока.МобильныйТелефон = Глубина5.ТекстовоеСодержимое;
											ИначеЕсли Глубина5.ИмяУзла = "privateEmail" Тогда
												НоваяСтрока.ЭлПочта = Глубина5.ТекстовоеСодержимое;
											КонецЕсли;
										КонецЦикла;
									КонецЕсли;
								КонецЦикла;
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
				КонецЦикла;   
			КонецЕсли;
			
			Если Глубина1.ИмяУзла = "healthCareClaim" Тогда 
				Для Каждого Глубина2 Из Глубина1.Атрибуты Цикл
					Если Глубина2.ИмяУзла = "healthCareClaimNumber" Тогда
						АктОказанияУслуг = Документы.АктОказанияУслуг.НайтиПоНомеру(Глубина2.ЗначениеУзла);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		Страховаякомпания = ПолучитьстраховуюКомпанию(ИНН, КПП);
		
		Если Не ЗначениеЗаполнено(Страховаякомпания) Тогда
			
			ГруппаСК = Справочники.Контрагенты.ПолучитьПапкуПоТипу(Перечисления.ТипыКонтрагентов.СтраховаяКомпания);
			Если Не ЗначениеЗаполнено(ГруппаСК) Тогда
				ГруппаСК                 = Справочники.Контрагенты.СоздатьГруппу();
				ГруппаСК.Наименование    = "Страховые компании";
				ГруппаСК.ТипКонтрагента  = Перечисления.ТипыКонтрагентов.СтраховаяКомпания;
				ГруппаСК.Записать();
			КонецЕсли;
			
			Страховаякомпания = Справочники.Контрагенты.СоздатьЭлемент();		
			
			Страховаякомпания.Наименование          = НаименованиеСК;
			Страховаякомпания.Родитель			 	= ГруппаСК;
			Страховаякомпания.ДатаРегистрации		= ТекущаяДатаСеанса();
			Страховаякомпания.СтруктурнаяЕдиница	= ПараметрыСеанса.ТекущаяСтруктурнаяЕдиница;
			Страховаякомпания.ЮрФизЛицо			 	= Перечисления.ЮрФизЛицо.ЮрЛицо;
			Страховаякомпания.СотрудникРегистрации  = ПараметрыСеанса.АвторизованныйПользователь;
			Страховаякомпания.ТипКонтрагента		= Перечисления.ТипыКонтрагентов.СтраховаяКомпания; 
			Страховаякомпания.ИНН					= ИНН; 
			Страховаякомпания.КПП					= КПП; 
			Попытка
				Страховаякомпания.Записать();
			Исключение
				Возврат 400;
			КонецПопытки;
			
		КонецЕсли;
		
		ДоговорСоСтраховой = ПолучитьДоговорСоСтраховой(Страховаякомпания.Ссылка, НомерДоговора, ДатаДоговора);
		
		Если Не ЗначениеЗаполнено(ДоговорСоСтраховой) Тогда
			
			ДоговорСоСтраховой = Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
			
			ДоговорСоСтраховой.Контрагент 			  = Страховаякомпания.Ссылка;
			ДоговорСоСтраховой.НомерДоговора 		  = НомерДоговора;
			ДоговорСоСтраховой.ДатаДоговора 		  = ДатаДоговора;
			
			
			ТекстНаименования = НСтр("ru = 'Основной Договор № %НомерДоговора% от %ДатаДоговора% c %Страховаякомпания%'");   
			ТекстНаименования = СтрЗаменить(ТекстНаименования, "%НомерДоговора%", СокрЛП(ДоговорСоСтраховой.НомерДоговора));
			ТекстНаименования = СтрЗаменить(ТекстНаименования, "%ДатаДоговора%", ?(ЗначениеЗаполнено(ДоговорСоСтраховой.ДатаДоговора), 
			СокрЛП(Строка(Формат(ДоговорСоСтраховой.ДатаДоговора, "ДФ=dd.MM.yyyy"))), ""));
			ТекстНаименования = СтрЗаменить(ТекстНаименования, "%Страховаякомпания%", СокрЛП(Страховаякомпания));
			
			ДоговорСоСтраховой.Наименование = ТекстНаименования;
			
			Попытка
				ДоговорСоСтраховой.Записать();
			Исключение 
				Возврат 400;
			КонецПопытки;
		КонецЕсли;         
		
		ОригинальныйПациент = Неопределено;
		
		Для Каждого Полис Из ТаблицаЗастрахованных Цикл
			
			ДатаРождения = Формат(Полис.ДатаРождения, "ДФ=yyyy.MM.dd");

			Если ТипСообщения = 3 И Полис.Дубль И ЗначениеЗаполнено(ОригинальныйПациент) Тогда
				ПациентОбъект = ОригинальныйПациент.ПолучитьОбъект();
				ПациентОбъект.Фамилия 		=Полис.Фамилия;
				ПациентОбъект.Имя           =Полис.Имя;
				ПациентОбъект.Отчество      =Полис.Отчество;
				ПациентОбъект.ДатаРождения  =ДатаРождения;
				ПациентОбъект.Пол           =Полис.Пол; 
				ПациентОбъект.КонтактнаяИнформация.Очистить();
				Если ЗначениеЗаполнено(Полис.Адрес) Тогда
					Результат = РаботаСАдресами.КонвертироватьАдресИзJSONВXML(Полис.Адрес, "", Перечисления.ТипыКонтактнойИнформации.Адрес);
					ЗаполнитьАдрес(ПациентОбъект, Результат, Справочники.ВидыКонтактнойИнформации.АдресКлиента);
				КонецЕсли;
				Если ЗначениеЗаполнено(Полис.МобильныйТелефон) Тогда
					УправлениеКонтактнойИнформациейСтоматология.ПреобразоватьНомерТелефона(Полис.МобильныйТелефон, Новый СписокЗначений);	
					Справочники.Контрагенты.ДобавитьНомерТелефонаВКонтактнуюИнформациюКлиента(ПациентОбъект, Полис.МобильныйТелефон);
				КонецЕсли;
				Если ЗначениеЗаполнено(Полис.ДомашнийТелефон) Тогда
					УправлениеКонтактнойИнформациейСтоматология.ПреобразоватьНомерТелефона(Полис.ДомашнийТелефон, Новый СписокЗначений);	
					Справочники.Контрагенты.ДобавитьНомерТелефонаВКонтактнуюИнформациюКлиента(ПациентОбъект, Полис.ДомашнийТелефон);
				КонецЕсли; 
				Если ЗначениеЗаполнено(Полис.ЭлПочта) Тогда
					Справочники.Контрагенты.ДобавитьEmailВКонтактнуюИнформациюКлиента(ПациентОбъект, Полис.ЭлПочта);
				КонецЕсли;
			Иначе
				Пациент = ПолучитьПациента(Полис.Фамилия, Полис.Имя, Полис.Отчество, Полис.ДатаРождения);
				Если Не ЗначениеЗаполнено(Пациент) Тогда
					Пациент = Справочники.Контрагенты.СоздатьКлиента(Полис.Фамилия, 
																	 Полис.Имя, 
																	 Полис.Отчество, 
																	 Полис.МобильныйТелефон, 
																	 Полис.ЭлПочта, 
																	 ПараметрыСеанса.ТекущаяСтруктурнаяЕдиница, 
																	 ДатаРождения, 
																	 Полис.Пол, 
																	 Полис.Адрес);   	
				КонецЕсли;
				ПациентОбъект = Пациент.ПолучитьОбъект();  
				НайденныеСтроки = ПациентОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("НомерТелефона, Тип", Полис.ДомашнийТелефон, Перечисления.ТипыКонтактнойИнформации.Телефон));
				Если НайденныеСтроки.Количество() = 0 Тогда
					УправлениеКонтактнойИнформациейСтоматология.ПреобразоватьНомерТелефона(Полис.ДомашнийТелефон, Новый СписокЗначений);	
					Справочники.Контрагенты.ДобавитьНомерТелефонаВКонтактнуюИнформациюКлиента(ПациентОбъект, Полис.ДомашнийТелефон);
				КонецЕсли;
				ПациентОбъект.СоциальныйСтатус  = Справочники.СоциальныеСтатусыКонтрагентов.Работающий; 
				ПациентОбъект.Организация 		= Полис.Страхователь;  
				
			КонецЕсли;

			Попытка
				ПациентОбъект.Записать();
			Исключение
				Возврат 400;
			КонецПопытки;
			
			Если ТипСообщения = 3 И Не Полис.Дубль Тогда
				ОригинальныйПациент = Пациент;		
			КонецЕсли;
			
			ПолисПациента = ПолучитьПолисПациента(Пациент, Полис.НомерПолиса);
			
			Если ТипСообщения = 2 Тогда
				Если ЗначениеЗаполнено(ПолисПациента) Тогда
					ПолисПациента.ДатаОкончания 		= Полис.ОткрепленС;
					Попытка
						ПолисПациента.Записать();
					Исключение 
						Возврат 400;
					КонецПопытки; 
				КонецЕсли;
				Возврат 200;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ПолисПациента) Или (ТипСообщения = 3 И Полис.Дубль) Тогда
				
				Если Не ЗначениеЗаполнено(ПолисПациента) Тогда
					ПолисПациента = Справочники.ПолисыМедицинскогоСтрахования.СоздатьЭлемент();		
				Иначе
					ПолисПациентаОбъект = ПолисПациента.ПолучитьОбъект();
				КонецЕсли;
			
				ПолисПациента.Контрагент 			= Пациент;
				ПолисПациента.ТипПолиса 			= Перечисления.ТипыПолиса.ДобровольноеМедицинскоеСтрахование;
				ПолисПациента.СтраховаяКомпания 	= Страховаякомпания.Ссылка;
				ПолисПациента.НомерПолиса 			= Полис.НомерПолиса;
				ПолисПациента.ДанаНачала 			= Полис.ДействуетС;
				ПолисПациента.ДатаОкончания 		= Полис.ДействуетПО; 
				ПолисПациента.Договор 				= ДоговорСоСтраховой.Ссылка;
				// ПолисПациента.Организация 			= Полис.Страхователь;
				ПолисПациента.ПрограммаПрикрепления = Полис.ПрограммаПрикрепления;
				
				Попытка
					ПолисПациента.Записать();
				Исключение 
					Возврат 400;
				КонецПопытки; 
	
			КонецЕсли;	
			
		КонецЦикла;
		
		ИспользоватьСистемуВзаимодействия = ОбсужденияСистемыВзаимодействия.СистемаВзаимодействияВключена();
		
		МассивРолей = Новый Массив;
		МассивРолей.Добавить(Перечисления.РольПользователя.АдминистраторБазыДанных);
		МассивРолей.Добавить(Перечисления.РольПользователя.Бухгалтер);
		МассивРолей.Добавить(Перечисления.РольПользователя.Регистратура);
		МассивРолей.Добавить(Перечисления.РольПользователя.Руководитель);
		МассивРолей.Добавить(Перечисления.РольПользователя.Управляющий);
		
		МассивСотрудников = Справочники.Сотрудники.ПолучитьМассивСотрудниковПоРолям(МассивРолей);
		
		Если ИспользоватьСистемуВзаимодействия = Истина Тогда
			
			Если ЗначениеЗаполнено(МассивСотрудников) Тогда 
				
				// Оповещение через систему взаимодействия.
				КлючЗаписи = ПолучитьКлючЗаписи(НомерСписка);
				ДанныеСообщения = Новый Структура;
				ДанныеСообщения.Вставить("Ключ"			, "НовоеСообщениеКонтурСтрохование");
				ДанныеСообщения.Вставить("КлючЗаписи"	, НомерСписка); 
				ДанныеСообщения.Вставить("mediId"		, КлючЗаписи.mediId);
				ДанныеСообщения.Вставить("eventId"		, КлючЗаписи.eventId);
				ДанныеСообщения.Вставить("eventPointer"	, КлючЗаписи.eventPointer);
				ДанныеСообщения.Вставить("eventDateTime", КлючЗаписи.eventDateTime);
				ДанныеСообщения.Вставить("ТипСообщения" , ТипСообщения);
				ДанныеСообщения.Вставить("СтруктурнаяЕдиница"	, ПараметрыСеанса.ТекущаяСтруктурнаяЕдиница);
				
				ОбсужденияСистемыВзаимодействия.ДобавитьСообщениеВСистемуВзаимодействия(ДанныеСообщения, МассивСотрудников); 
				
			КонецЕсли;				
		Иначе
			
			// Оповещение через регистр сведений.          
			КлючЗаписи = ПолучитьКлючЗаписи(НомерСписка);
			Для Каждого Сотрудник Из МассивСотрудников Цикл
				ПараметрыОповещения = Новый_Массив(НомерСписка,  КлючЗаписи.mediId, КлючЗаписи.eventId,КлючЗаписи.eventPointer,КлючЗаписи.eventDateTime, ТипСообщения);
				РегистрыСведений.ОповещениеМониторингКлиента.ДобавитьОповещениеКлиента(Сотрудник,
				Неопределено, 
				"НовоеСообщениеКонтурСтрохование", 
				ТекущаяДатаСеанса(),,,, 
				ПараметрыОповещения);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;   
	
	Возврат 200;
	
КонецФункции

Функция ПолучитьстраховуюКомпанию(ИНН, КПП)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ИНН = &ИНН
	|	И Контрагенты.КПП = &КПП
	|	И Контрагенты.ТипКонтрагента = &ТипКонтрагента";
	
	Запрос.УстановитьПараметр("ИНН", ИНН);
	Запрос.УстановитьПараметр("КПП", КПП);
	Запрос.УстановитьПараметр("ТипКонтрагента", Перечисления.ТипыКонтрагентов.СтраховаяКомпания);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;	
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат	Выборка.Ссылка;	
	КонецЕсли;
	
КонецФункции

Функция ПолучитьДоговорСоСтраховой(Страховаякомпания, НомерДоговора, ДатаДоговора)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Контрагент = &Контрагент
	|	И ДоговорыКонтрагентов.НомерДоговора = &НомерДоговора
	|	И ДоговорыКонтрагентов.ДатаДоговора = &ДатаДоговора";
	
	Запрос.УстановитьПараметр("Контрагент"		, Страховаякомпания); 
	Запрос.УстановитьПараметр("НомерДоговора"	, НомерДоговора);
	Запрос.УстановитьПараметр("ДатаДоговора"	, ДатаДоговора);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;	
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат	Выборка.Ссылка;	
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПациента(Фамилия, Имя, Отчество, ДатаРождения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Фамилия = &Фамилия
	|	И Контрагенты.Имя = &Имя
	|	И Контрагенты.Отчество = &Отчество
	|	И Контрагенты.ДатаРожденияКлиента = &ДатаРожденияКлиента";
	
	Запрос.УстановитьПараметр("Фамилия"				, Фамилия);
	Запрос.УстановитьПараметр("Имя"					, Имя);
	Запрос.УстановитьПараметр("Отчество"			, Отчество);
	Запрос.УстановитьПараметр("ДатаРожденияКлиента"	, ДатаРождения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;	
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат	Выборка.Ссылка;	
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПолисПациента(Пациент, НомерПолиса)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПолисыМедицинскогоСтрахования.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПолисыМедицинскогоСтрахования КАК ПолисыМедицинскогоСтрахования
	|ГДЕ
	|	ПолисыМедицинскогоСтрахования.Контрагент = &Контрагент
	|	И ПолисыМедицинскогоСтрахования.НомерПолиса = &НомерПолиса";
	
	Запрос.УстановитьПараметр("Контрагент"		, Пациент);
	Запрос.УстановитьПараметр("НомерПолиса"		, НомерПолиса);
	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;	
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат	Выборка.Ссылка;	
	КонецЕсли;
	
КонецФункции

Функция JSON_Прочитать(Значение) Экспорт
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Значение);
	
	Результат = ПрочитатьJSON(ЧтениеJSON, Истина);
	
	Возврат Результат;
	
КонецФункции

Процедура URL_УстановитьПараметр(АдресРесурса, Ключ, Значение) Экспорт
	
	Если СтрНайти(АдресРесурса, СтрШаблон("{%1}", Ключ)) <> 0 Тогда
		URL_УстановитьПараметрПуть(АдресРесурса, Ключ, Значение);
	Иначе
		URL_УстановитьПараметрЗапрос(АдресРесурса, Ключ, Значение);
	КонецЕсли;
	
КонецПроцедуры

Процедура URL_УстановитьПараметрПуть(АдресРесурса, Ключ, Значение) Экспорт
	
	ЧастиАдреса = СтрРазделить(АдресРесурса, "?", Истина);
	Если ЧастиАдреса.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЧастиАдреса[0] = СтрЗаменить(
	ЧастиАдреса[0], 
	СтрШаблон("{%1}", Ключ), 
	URL_Кодировать(Значение));
	
	АдресРесурса = СтрСоединить(ЧастиАдреса, "?");
	
КонецПроцедуры

Процедура URL_УстановитьПараметрЗапрос(АдресРесурса, Ключ, Значение) Экспорт
	
	ЧастиАдреса = СтрРазделить(АдресРесурса, "?", Истина);
	
	Если ЧастиАдреса.Количество() = 0 Тогда
		Возврат;
	ИначЕесли ЧастиАдреса.Количество() = 1 Тогда
		ЧастиАдреса.Добавить();
	ИначеЕсли ЧастиАдреса.Количество() > 2 Тогда
		ВызватьИсключение "Не предполагаемый формат URL";
	КонецЕсли;
	
	ПараметрыАдреса	= СтрРазделить(ЧастиАдреса[1], "&", Ложь);
	ПараметрыИндекс = Неопределено;
	
	Сч = -1;
	
	Для Каждого Элемент Из ПараметрыАдреса Цикл
		
		Сч = Сч + 1;
		
		Параметр = СтрРазделить(Элемент, "=", Истина);
		Если Параметр.Количество() <> 2 Тогда
			Продолжить;	
		КонецЕсли;
		
		Если Параметр[0] = Ключ Тогда
			ПараметрыИндекс = Сч;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;		
	
	Параметр = СтрШаблон("%1=%2", Ключ, XMLСтрока(Значение));
	
	Если ПараметрыИндекс = Неопределено Тогда
		ПараметрыАдреса.Добавить(Параметр);
	Иначе
		ПараметрыАдреса[ПараметрыИндекс] = Параметр;
	КонецЕсли;
	
	ЧастиАдреса[1] 		 = СтрСоединить(ПараметрыАдреса, "&");
	АдресРесурса = СтрСоединить(ЧастиАдреса, "?");
	
КонецПроцедуры

Функция URL_Кодировать(Параметр) Экспорт
	
	Если ТипЗнч(Параметр) = Тип("Строка") Тогда
		
		Возврат КодироватьСтроку(Параметр, СпособКодированияСтроки.КодировкаURL);	
		
	ИначеЕсли ТипЗнч(Параметр) = Тип("Структура")
		ИЛИ ТипЗнч(Параметр) = Тип("Соответствие") Тогда
		
		МассивПараметров = Новый Массив;	
		
		Для Каждого Элемент Из Параметр Цикл
			
			Если Элемент.Значение = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Параметр = СтрШаблон("%1=%2", Элемент.Ключ, XMLСтрока(Элемент.Значение));
			МассивПараметров.Добавить(Параметр);
			
		КонецЦикла;
		
		Строка = СтрСоединить(МассивПараметров, "&");
		
		Возврат КодироватьСтроку(Строка, СпособКодированияСтроки.URLВКодировкеURL);
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьКлючЗаписи(НомерСписка) Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СообщенияКонтурСтрахование.mediId КАК mediId,
	|	СообщенияКонтурСтрахование.eventId КАК eventId,
	|	СообщенияКонтурСтрахование.eventPointer КАК eventPointer,
	|	СообщенияКонтурСтрахование.eventDateTime КАК eventDateTime
	|ИЗ
	|	РегистрСведений.СообщенияКонтурСтрахование КАК СообщенияКонтурСтрахование
	|ГДЕ
	|	СообщенияКонтурСтрахование.documentNumber = &НомерСписка";
	
	Запрос.УстановитьПараметр("НомерСписка"		, НомерСписка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;	
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		ЗначениеКлюча = Новый Структура;
    	ЗначениеКлюча.Вставить("mediId"			, Выборка.mediId);
        ЗначениеКлюча.Вставить("eventId"		, Выборка.eventId);
		ЗначениеКлюча.Вставить("eventPointer"	, Выборка.eventPointer);
		ЗначениеКлюча.Вставить("eventDateTime"	, Выборка.eventDateTime);
		
	    Возврат ЗначениеКлюча;
	КонецЕсли;

КонецФункции

Функция SetMessageStatus(messageId,status,description) Экспорт 
	
	ВнешняяСистемаКС = Справочники.ВнешниеСистемы.ПолучитьВнешнююСистему(,Перечисления.ТипыВнешнихСистем.КонтурСтрахование, Истина);
	token = ВнешняяСистемаКС.ТокенДоступа;
	
	ПараметрыВС = ВнешняяСистемаКС.Параметры.Получить();
	
	Если ПараметрыВС.Демо Тогда
		АдресСервера = "medi-api.testkontur.ru";	
	Иначе
		АдресСервера = "medi-api.kontur.ru";	
	КонецЕсли;

	Запрос = Новый HTTPЗапрос("/V2/messages/{messageId}/status");
	Запрос.Заголовки.Вставить("Authorization", "Bearer "+token);
	Запрос.Заголовки.Вставить("Content-Type", "application/json");
	СтрокаJSON = "{ ""checkingStatus"": """ + status + """, ""description"": """ + description + """}";
	
	Запрос.УстановитьТелоИзСтроки(СтрокаJSON,КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	URL_УстановитьПараметр(Запрос.АдресРесурса, "messageId", messageId);
	
	Ответ = ВыполнитьHTTPМетодСервер("POST", Запрос, АдресСервера);
	
	Если Ответ.КодСостояния = 200 Тогда
		Возврат Истина;
	ИначеЕсли Ответ.КодСостояния = 404 Тогда
		ТекстСообщения = НСтр("ru = 'Сообщение не найдено: '" + Ответ.ПолучитьТелоКакСтроку());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	ИначеЕсли Ответ.КодСостояния = 401 Тогда
		ТекстСообщения = НСтр("ru = 'Запрос не авторизован: '" + Ответ.ПолучитьТелоКакСтроку());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	ИначеЕсли Ответ.КодСостояния = 400 Тогда
		ТекстСообщения = НСтр("ru = 'Некорректный формат идентификатора сообщения: '" + Ответ.ПолучитьТелоКакСтроку());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	ИначеЕсли Ответ.КодСостояния >= 300 Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось выполнить запрос: '" + Ответ.ПолучитьТелоКакСтроку());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось выполнить запрос: '" + Ответ.ПолучитьТелоКакСтроку());
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ПроверитьСообщение(messageId, eventType, description, reasons)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СообщенияКонтурСтрахование.messageId КАК messageId,
	|	СообщенияКонтурСтрахование.mediId КАК mediId,
	|	СообщенияКонтурСтрахование.eventId КАК eventId,
	|	СообщенияКонтурСтрахование.eventPointer КАК eventPointer,
	|	СообщенияКонтурСтрахование.eventDateTime КАК eventDateTime,
	|	СообщенияКонтурСтрахование.eventType КАК eventType,
	|	СообщенияКонтурСтрахование.documentType КАК documentType
	|ИЗ
	|	РегистрСведений.СообщенияКонтурСтрахование КАК СообщенияКонтурСтрахование
	|ГДЕ
	|	СообщенияКонтурСтрахование.messageId = &messageId";
	
	Запрос.УстановитьПараметр("messageId", messageId);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Процедура - Заполнить адрес
//
// Параметры:
//  НовыйЭлемент		 - 	 - 
//  Объект_XDTO_Адрес	 - 	 - 
//  ВидКИ				 - 	 - 
//
Процедура ЗаполнитьАдрес(НовыйЭлемент, Знач Объект_XDTO_Адрес, Знач ВидКИ)
	
	Если Объект_XDTO_Адрес = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	НоваяСтрока 				= НовыйЭлемент.КонтактнаяИнформация.Добавить();
	НоваяСтрока.Тип 			= Перечисления.ТипыКонтактнойИнформации.Адрес;
	НоваяСтрока.Вид 			= ВидКИ;
	НоваяСтрока.Страна 			= ?(Объект_XDTO_Адрес.Состав.Страна = Неопределено, "", Объект_XDTO_Адрес.Состав.Страна);
	Если 	НоваяСтрока.Страна = "Россия" Тогда 
		НоваяСтрока.Регион 			= ?(Объект_XDTO_Адрес.Состав.Состав.СубъектРФ = Неопределено, "", Объект_XDTO_Адрес.Состав.Состав.СубъектРФ);	
		НоваяСтрока.Город 			= ?(Объект_XDTO_Адрес.Состав.Состав.Город = Неопределено, "", Объект_XDTO_Адрес.Состав.Состав.Город);
		НоваяСтрока.ЗначенияПолей 	= УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияXDTOВXML(Объект_XDTO_Адрес);
		НоваяСтрока.Значение 		= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Объект_XDTO_Адрес.Представление, ВидКИ);
		НоваяСтрока.Представление 	= Объект_XDTO_Адрес.Представление;
	Иначе 
		НоваяСтрока.Представление 	= ?(Объект_XDTO_Адрес.Представление <> "", Объект_XDTO_Адрес.Представление, НоваяСтрока.Страна); 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти