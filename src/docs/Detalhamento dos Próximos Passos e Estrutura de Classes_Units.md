# Detalhamento dos Próximos Passos e Estrutura de Classes/Units

Este documento detalha as classes e units necessárias para implementação do cronograma proposto, organizadas por fase e com foco na arquitetura ORM moderna para Delphi.

## Fase 1: Reestruturação da Arquitetura Base

### Novas Units e Classes para Implementação do Padrão Unit of Work

#### 1. `core.orm.unitofwork.intf.pas`
```pascal
unit core.orm.unitofwork.intf;

interface
uses
  System.SysUtils, System.Classes, core.db.connection.intf;

type
  IUnitOfWork = interface
    ['{A5F8D3E2-B7C1-4D9A-8F43-6E2D1B5A7C0E}']
    function GetConnection: IFUPConnection;
    
    function BeginTransaction: Boolean;
    function Commit: Boolean;
    function Rollback: Boolean;
    
    function IsInTransaction: Boolean;
    
    // Registro de repositórios
    procedure RegisterRepository(const ARepositoryName: string; const ARepository: IInterface);
    function GetRepository<T: IInterface>(const ARepositoryName: string): T;
  end;
```

#### 2. `core.orm.unitofwork.pas`
```pascal
unit core.orm.unitofwork;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  core.orm.unitofwork.intf, core.db.connection.intf, core.orm.logger.intf;

type
  TUnitOfWork = class(TInterfacedObject, IUnitOfWork)
  private
    FConnection: IFUPConnection;
    FRepositories: TDictionary<string, IInterface>;
    FLogger: ILogger;
  public
    constructor Create(AConnection: IFUPConnection; ALogger: ILogger);
    destructor Destroy; override;
    
    function GetConnection: IFUPConnection;
    
    function BeginTransaction: Boolean;
    function Commit: Boolean;
    function Rollback: Boolean;
    
    function IsInTransaction: Boolean;
    
    procedure RegisterRepository(const ARepositoryName: string; const ARepository: IInterface);
    function GetRepository<T: IInterface>(const ARepositoryName: string): T;
  end;
```

### Novas Units e Classes para Implementação do Padrão Repository

#### 3. `core.orm.repository.intf.pas`
```pascal
unit core.orm.repository.intf;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  core.sql.entity, core.db.connection.intf;

type
  IRepository<T: TBaseEntity> = interface
    ['{B7E2D1C9-A3F8-4E5D-9B6C-7A8D2E1F0B5C}']
    function GetById(const AId: TValue): T;
    function GetAll: TObjectList<T>;
    function Find(const ACriteria: TDBCriteria): TObjectList<T>;
    
    function Add(const AEntity: T): Boolean;
    function Update(const AEntity: T): Boolean;
    function Remove(const AEntity: T): Boolean;
    
    function Count(const ACriteria: TDBCriteria = nil): Integer;
    function Exists(const ACriteria: TDBCriteria): Boolean;
    
    function GetConnection: IFUPConnection;
  end;
```

#### 4. `core.orm.repository.pas`
```pascal
unit core.orm.repository;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Rtti,
  core.orm.repository.intf, core.sql.entity, core.db.connection.intf,
  core.sql.builder, core.orm.logger.intf;

type
  TRepository<T: TBaseEntity, constructor> = class(TInterfacedObject, IRepository<T>)
  private
    FConnection: IFUPConnection;
    FSQLBuilder: TSQLBuilder;
    FLogger: ILogger;
  public
    constructor Create(AConnection: IFUPConnection; ALogger: ILogger);
    destructor Destroy; override;
    
    function GetById(const AId: TValue): T;
    function GetAll: TObjectList<T>;
    function Find(const ACriteria: TDBCriteria): TObjectList<T>;
    
    function Add(const AEntity: T): Boolean;
    function Update(const AEntity: T): Boolean;
    function Remove(const AEntity: T): Boolean;
    
    function Count(const ACriteria: TDBCriteria = nil): Integer;
    function Exists(const ACriteria: TDBCriteria): Boolean;
    
    function GetConnection: IFUPConnection;
  end;
```

### Sistema de Logging

#### 5. `core.orm.logger.intf.pas`
```pascal
unit core.orm.logger.intf;

interface
uses
  System.SysUtils, System.Classes;

type
  TLogLevel = (llDebug, llInfo, llWarning, llError, llFatal);
  
  ILogger = interface
    ['{C9D8E7F6-A5B4-3C2D-1E0F-9G8H7I6J5K4L}']
    procedure Log(const ALevel: TLogLevel; const AMessage: string); overload;
    procedure Log(const ALevel: TLogLevel; const AMessage: string; const AException: Exception); overload;
    
    procedure Debug(const AMessage: string);
    procedure Info(const AMessage: string);
    procedure Warning(const AMessage: string);
    procedure Error(const AMessage: string); overload;
    procedure Error(const AMessage: string; const AException: Exception); overload;
    procedure Fatal(const AMessage: string); overload;
    procedure Fatal(const AMessage: string; const AException: Exception); overload;
  end;
```

#### 6. `core.orm.logger.pas`
```pascal
unit core.orm.logger;

interface
uses
  System.SysUtils, System.Classes, System.SyncObjs,
  core.orm.logger.intf;

type
  TLogger = class(TInterfacedObject, ILogger)
  private
    FLogFile: string;
    FLogLevel: TLogLevel;
    FCriticalSection: TCriticalSection;
  public
    constructor Create(const ALogFile: string; ALogLevel: TLogLevel = llInfo);
    destructor Destroy; override;
    
    procedure Log(const ALevel: TLogLevel; const AMessage: string); overload;
    procedure Log(const ALevel: TLogLevel; const AMessage: string; const AException: Exception); overload;
    
    procedure Debug(const AMessage: string);
    procedure Info(const AMessage: string);
    procedure Warning(const AMessage: string);
    procedure Error(const AMessage: string); overload;
    procedure Error(const AMessage: string; const AException: Exception); overload;
    procedure Fatal(const AMessage: string); overload;
    procedure Fatal(const AMessage: string; const AException: Exception); overload;
  end;
```

### Sistema de Injeção de Dependência

#### 7. `core.orm.ioc.pas`
```pascal
unit core.orm.ioc;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Rtti;

type
  TDependencyLifetime = (dlTransient, dlSingleton, dlScoped);

  IDependencyContainer = interface
    ['{D1E2F3A4-B5C6-7D8E-9F0A-1B2C3D4E5F6A}']
    procedure RegisterType<TInterface: IInterface; TImplementation: class>(ALifetime: TDependencyLifetime = dlTransient);
    procedure RegisterInstance<TInterface: IInterface>(const AInstance: TInterface);
    function Resolve<T: IInterface>: T;
  end;
  
  TDependencyContainer = class(TInterfacedObject, IDependencyContainer)
  private
    FRegistrations: TDictionary<TGUID, TValue>;
    FSingletons: TDictionary<TGUID, TValue>;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure RegisterType<TInterface: IInterface; TImplementation: class>(ALifetime: TDependencyLifetime = dlTransient);
    procedure RegisterInstance<TInterface: IInterface>(const AInstance: TInterface);
    function Resolve<T: IInterface>: T;
  end;
```

## Fase 2: Aprimoramento do Mapeamento Objeto-Relacional

### Mapeamento de Relacionamentos

#### 8. `core.orm.relations.pas`
```pascal
unit core.orm.relations;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  core.sql.attributes, core.sql.entity;

type
  TRelationAttribute = class(TCustomAttribute)
  private
    FTargetEntity: string;
    FMappedBy: string;
    FJoinColumn: string;
    FJoinTable: string;
    FCascade: TCascadeActions;
    FFetchType: TFetchType;
  public
    constructor Create(const ATargetEntity: string; 
                      const AMappedBy: string = ''; 
                      const AJoinColumn: string = '';
                      const AJoinTable: string = '';
                      ACascade: TCascadeActions = [];
                      AFetchType: TFetchType = ftLazy);
  published
    property TargetEntity: string read FTargetEntity;
    property MappedBy: string read FMappedBy;
    property JoinColumn: string read FJoinColumn;
    property JoinTable: string read FJoinTable;
    property Cascade: TCascadeActions read FCascade;
    property FetchType: TFetchType read FFetchType;
  end;
  
  OneToOne = class(TRelationAttribute);
  OneToMany = class(TRelationAttribute);
  ManyToOne = class(TRelationAttribute);
  ManyToMany = class(TRelationAttribute);
```

#### 9. `core.orm.entitymanager.pas`
```pascal
unit core.orm.entitymanager;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Rtti,
  core.db.connection.intf, core.sql.entity, core.orm.unitofwork.intf,
  core.orm.logger.intf;

type
  IEntityManager = interface
    ['{E1F2D3C4-B5A6-7D8E-9F0A-1B2C3D4E5F6A}']
    function Find<T: TBaseEntity, constructor>(const AId: TValue): T;
    function FindAll<T: TBaseEntity, constructor>: TObjectList<T>;
    function FindBy<T: TBaseEntity, constructor>(const ACriteria: TDBCriteria): TObjectList<T>;
    
    function Persist<T: TBaseEntity>(const AEntity: T): Boolean;
    function Remove<T: TBaseEntity>(const AEntity: T): Boolean;
    
    function GetUnitOfWork: IUnitOfWork;
  end;
  
  TEntityManager = class(TInterfacedObject, IEntityManager)
  private
    FUnitOfWork: IUnitOfWork;
    FLogger: ILogger;
    FEntitiesCache: TDictionary<string, TObject>;
  public
    constructor Create(AUnitOfWork: IUnitOfWork; ALogger: ILogger);
    destructor Destroy; override;
    
    function Find<T: TBaseEntity, constructor>(const AId: TValue): T;
    function FindAll<T: TBaseEntity, constructor>: TObjectList<T>;
    function FindBy<T: TBaseEntity, constructor>(const ACriteria: TDBCriteria): TObjectList<T>;
    
    function Persist<T: TBaseEntity>(const AEntity: T): Boolean;
    function Remove<T: TBaseEntity>(const AEntity: T): Boolean;
    
    function GetUnitOfWork: IUnitOfWork;
  end;
```

### Consultas Avançadas e Lazy Loading

#### 10. `core.orm.querybuilder.pas`
```pascal
unit core.orm.querybuilder;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  core.sql.entity, core.sql.attributes;

type
  TJoinType = (jtInner, jtLeft, jtRight, jtFull);
  
  IQueryBuilder<T: TBaseEntity> = interface
    ['{F1E2D3C4-B5A6-7D8E-9F0A-1B2C3D4E5F6A}']
    function Select(const AFields: array of string): IQueryBuilder<T>; overload;
    function Select: IQueryBuilder<T>; overload;
    
    function Join<U: TBaseEntity>(const AAlias: string; const AOn: string; AJoinType: TJoinType = jtInner): IQueryBuilder<T>;
    function Where(const ACondition: string): IQueryBuilder<T>;
    function AndWhere(const ACondition: string): IQueryBuilder<T>;
    function OrWhere(const ACondition: string): IQueryBuilder<T>;
    
    function OrderBy(const AField: string; AAscending: Boolean = True): IQueryBuilder<T>;
    function GroupBy(const AField: string): IQueryBuilder<T>;
    function Having(const ACondition: string): IQueryBuilder<T>;
    
    function Limit(ACount: Integer): IQueryBuilder<T>;
    function Offset(AStart: Integer): IQueryBuilder<T>;
    
    function SetParameter(const AName: string; const AValue: TValue): IQueryBuilder<T>;
    
    function GetSQL: string;
    function GetParameters: TDictionary<string, TValue>;
  end;
  
  TQueryBuilder<T: TBaseEntity> = class(TInterfacedObject, IQueryBuilder<T>)
  private
    FEntityClass: TClass;
    FSelect: TStringList;
    FFrom: string;
    FJoins: TStringList;
    FWhere: TStringList;
    FOrderBy: TStringList;
    FGroupBy: TStringList;
    FHaving: string;
    FLimit: Integer;
    FOffset: Integer;
    FParameters: TDictionary<string, TValue>;
  public
    constructor Create;
    destructor Destroy; override;
    
    function Select(const AFields: array of string): IQueryBuilder<T>; overload;
    function Select: IQueryBuilder<T>; overload;
    
    function Join<U: TBaseEntity>(const AAlias: string; const AOn: string; AJoinType: TJoinType = jtInner): IQueryBuilder<T>;
    function Where(const ACondition: string): IQueryBuilder<T>;
    function AndWhere(const ACondition: string): IQueryBuilder<T>;
    function OrWhere(const ACondition: string): IQueryBuilder<T>;
    
    function OrderBy(const AField: string; AAscending: Boolean = True): IQueryBuilder<T>;
    function GroupBy(const AField: string): IQueryBuilder<T>;
    function Having(const ACondition: string): IQueryBuilder<T>;
    
    function Limit(ACount: Integer): IQueryBuilder<T>;
    function Offset(AStart: Integer): IQueryBuilder<T>;
    
    function SetParameter(const AName: string; const AValue: TValue): IQueryBuilder<T>;
    
    function GetSQL: string;
    function GetParameters: TDictionary<string, TValue>;
  end;
```

#### 11. `core.orm.proxy.pas`
```pascal
unit core.orm.proxy;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Rtti,
  core.sql.entity, core.orm.entitymanager;

type
  IEntityProxy = interface
    ['{A1B2C3D4-E5F6-A7B8-C9D0-E1F2A3B4C5D6}']
    function GetTarget: TObject;
    function IsLoaded: Boolean;
    procedure Load;
  end;
  
  TEntityProxy<T: TBaseEntity, constructor> = class(TInterfacedObject, IEntityProxy)
  private
    FTarget: T;
    FEntityManager: IEntityManager;
    FId: TValue;
    FLoaded: Boolean;
  public
    constructor Create(AEntityManager: IEntityManager; const AId: TValue);
    destructor Destroy; override;
    
    function GetTarget: TObject;
    function IsLoaded: Boolean;
    procedure Load;
  end;
  
  TCollectionProxy<T: TBaseEntity, constructor> = class(TInterfacedObject, IEntityProxy)
  private
    FCollection: TObjectList<T>;
    FEntityManager: IEntityManager;
    FOwnerEntity: TBaseEntity;
    FRelationProperty: string;
    FLoaded: Boolean;
  public
    constructor Create(AEntityManager: IEntityManager; AOwnerEntity: TBaseEntity; const ARelationProperty: string);
    destructor Destroy; override;
    
    function GetTarget: TObject;
    function IsLoaded: Boolean;
    procedure Load;
  end;
```

#### 12. `core.orm.cache.pas`
```pascal
unit core.orm.cache;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  core.sql.entity;

type
  ICacheProvider = interface
    ['{B1C2D3E4-F5A6-B7C8-D9E0-F1A2B3C4D5E6}']
    function Get<T: TBaseEntity>(const AKey: string): T;
    procedure Put<T: TBaseEntity>(const AKey: string; const AEntity: T);
    procedure Remove(const AKey: string);
    procedure Clear;
    function Contains(const AKey: string): Boolean;
  end;
  
  TFirstLevelCache = class(TInterfacedObject, ICacheProvider)
  private
    FCache: TDictionary<string, TObject>;
  public
    constructor Create;
    destructor Destroy; override;
    
    function Get<T: TBaseEntity>(const AKey: string): T;
    procedure Put<T: TBaseEntity>(const AKey: string; const AEntity: T);
    procedure Remove(const AKey: string);
    procedure Clear;
    function Contains(const AKey: string): Boolean;
  end;
  
  TSecondLevelCache = class(TInterfacedObject, ICacheProvider)
  private
    FCache: TDictionary<string, TObject>;
    FExpirations: TDictionary<string, TDateTime>;
    FDefaultExpiration: Integer; // em segundos
  public
    constructor Create(ADefaultExpiration: Integer = 300);
    destructor Destroy; override;
    
    function Get<T: TBaseEntity>(const AKey: string): T;
    procedure Put<T: TBaseEntity>(const AKey: string; const AEntity: T);
    procedure Remove(const AKey: string);
    procedure Clear;
    function Contains(const AKey: string): Boolean;
  end;
```

## Fase 3: Suporte a Múltiplos Bancos de Dados

### Dialetos SQL

#### 13. `core.orm.dialect.intf.pas`
```pascal
unit core.orm.dialect.intf;

interface
uses
  System.SysUtils, System.Classes, core.sql.attributes;

type
  ISQLDialect = interface
    ['{C1D2E3F4-A5B6-C7D8-E9F0-A1B2C3D4E5F6}']
    function QuoteIdentifier(const AIdentifier: string): string;
    function GetPagingSQL(const ASQL: string; AOffset, ALimit: Integer): string;
    function GetDateTimeFormat: string;
    function GetDateFormat: string;
    function GetTimeFormat: string;
    function GetBooleanFormat(AValue: Boolean): string;
    function GetAutoIncrementDDL(const AColumnName: string; AColumnType: TDBtype): string;
    function GetCreateTableDDL(const ATableName: string; const AColumns: TArray<string>; const APrimaryKey: string): string;
    function GetCreateIndexDDL(const AIndexName, ATableName, AColumnList: string; AUnique: Boolean): string;
    function GetDropTableDDL(const ATableName: string): string;
    function GetDropIndexDDL(const AIndexName, ATableName: string): string;
    function GetAlterTableAddColumnDDL(const ATableName, AColumnDefinition: string): string;
    function GetSequenceNextValSQL(const ASequenceName: string): string;
  end;
```

#### 14. `core.orm.dialect.base.pas`
```pascal
unit core.orm.dialect.base;

interface
uses
  System.SysUtils, System.Classes,
  core.orm.dialect.intf, core.sql.attributes;

type
  TBaseSQLDialect = class(TInterfacedObject, ISQLDialect)
  protected
    function GetIdentifierQuoteChar: Char; virtual;
  public
    function QuoteIdentifier(const AIdentifier: string): string; virtual;
    function GetPagingSQL(const ASQL: string; AOffset, ALimit: Integer): string; virtual;
    function GetDateTimeFormat: string; virtual;
    function GetDateFormat: string; virtual;
    function GetTimeFormat: string; virtual;
    function GetBooleanFormat(AValue: Boolean): string; virtual;
    function GetAutoIncrementDDL(const AColumnName: string; AColumnType: TDBtype): string; virtual;
    function GetCreateTableDDL(const ATableName: string; const AColumns: TArray<string>; const APrimaryKey: string): string; virtual;
    function GetCreateIndexDDL(const AIndexName, ATableName, AColumnList: string; AUnique: Boolean): string; virtual;
    function GetDropTableDDL(const ATableName: string): string; virtual;
    function GetDropIndexDDL(const AIndexName, ATableName: string): string; virtual;
    function GetAlterTableAddColumnDDL(const ATableName, AColumnDefinition: string): string; virtual;
    function GetSequenceNextValSQL(const ASequenceName: string): string; virtual;
  end;
```

#### 15. `core.orm.dialect.mysql.pas`
```pascal
unit core.orm.dialect.mysql;

interface
uses
  System.SysUtils, System.Classes,
  core.orm.dialect.base, core.sql.attributes;

type
  TMySQLDialect = class(TBaseSQLDialect)
  protected
    function GetIdentifierQuoteChar: Char; override;
  public
    function GetPagingSQL(const ASQL: string; AOffset, ALimit: Integer): string; override;
    function GetDateTimeFormat: string; override;
    function GetDateFormat: string; override;
    function GetTimeFormat: string; override;
    function GetBooleanFormat(AValue: Boolean): string; override;
    function GetAutoIncrementDDL(const AColumnName: string; AColumnType: TDBtype): string; override;
    function GetSequenceNextValSQL(const ASequenceName: string): string; override;
  end;
```

#### 16. `core.orm.dialect.postgres.pas`
```pascal
unit core.orm.dialect.postgres;

interface
uses
  System.SysUtils, System.Classes,
  core.orm.dialect.base, core.sql.attributes;

type
  TPostgreSQLDialect = class(TBaseSQLDialect)
  protected
    function GetIdentifierQuoteChar: Char; override;
  public
    function GetPagingSQL(const ASQL: string; AOffset, ALimit: Integer): string; override;
    function GetDateTimeFormat: string; override;
    function GetDateFormat: string; override;
    function GetTimeFormat: string; override;
    function GetBooleanFormat(AValue: Boolean): string; override;
    function GetAutoIncrementDDL(const AColumnName: string; AColumnType: TDBtype): string; override;
    function GetSequenceNextValSQL(const ASequenceName: string): string; override;
  end;
```

### Sistema de Migrações

#### 17. `core.orm.migration.pas`
```pascal
unit core.orm.migration;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  core.db.connection.intf, core.orm.dialect.intf;

type
  TMigrationVersion = record
    Major: Integer;
    Minor: Integer;
    Patch: Integer;
    function ToString: string;
    class function FromString(const AVersion: string): TMigrationVersion; static;
    class function Compare(const A, B: TMigrationVersion): Integer; static;
  end;

  IMigration = interface
    ['{D1E2F3A4-B5C6-D7E8-F9A0-B1C2D3E4F5A6}']
    function GetVersion: TMigrationVersion;
    function GetDescription: string;
    procedure Up(AConnection: IFUPConnection; ADialect: ISQLDialect);
    procedure Down(AConnection: IFUPConnection; ADialect: ISQLDialect);
  end;
  
  TMigration = class(TInterfacedObject, IMigration)
  private
    FVersion: TMigrationVersion;
    FDescription: string;
  public
    constructor Create(const AVersion: TMigrationVersion; const ADescription: string);
    function GetVersion: TMigrationVersion;
    function GetDescription: string;
    procedure Up(AConnection: IFUPConnection; ADialect: ISQLDialect); virtual; abstract;
    procedure Down(AConnection: IFUPConnection; ADialect: ISQLDialect); virtual; abstract;
  end;
  
  IMigrationManager = interface
    ['{E1F2A3B4-C5D6-E7F8-A9B0-C1D2E3F4A5B6}']
    procedure RegisterMigration(const AMigration: IMigration);
    function GetPendingMigrations: TArray<IMigration>;
    function GetAppliedMigrations: TArray<IMigration>;
    function GetCurrentVersion: TMigrationVersion;
    procedure MigrateUp(const ATargetVersion: TMigrationVersion); overload;
    procedure MigrateUp; overload;
    procedure MigrateDown(const ATargetVersion: TMigrationVersion);
    procedure CreateMigrationTable;
  end;
  
  TMigrationManager = class(TInterfacedObject, IMigrationManager)
  private
    FConnection: IFUPConnection;
    FDialect: ISQLDialect;
    FMigrations: TList<IMigration>;
    FMigrationTableName: string;
  public
    constructor Create(AConnection: IFUPConnection; ADialect: ISQLDialect; const AMigrationTableName: string = 'schema_migrations');
    destructor Destroy; override;
    
    procedure RegisterMigration(const AMigration: IMigration);
    function GetPendingMigrations: TArray<IMigration>;
    function GetAppliedMigrations: TArray<IMigration>;
    function GetCurrentVersion: TMigrationVersion;
    procedure MigrateUp(const ATargetVersion: TMigrationVersion); overload;
    procedure MigrateUp; overload;
    procedure MigrateDown(const ATargetVersion: TMigrationVersion);
    procedure CreateMigrationTable;
  end;
```

## Fase 4: Recursos Avançados e Otimizações

### Sistema de Validação

#### 18. `core.orm.validation.pas`
```pascal
unit core.orm.validation;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Rtti,
  core.sql.entity;

type
  TValidationResult = record
    IsValid: Boolean;
    ErrorMessage: string;
    PropertyName: string;
  end;
  
  TValidationResults = class
  private
    FErrors: TList<TValidationResult>;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure AddError(const APropertyName, AErrorMessage: string);
    function IsValid: Boolean;
    function GetErrors: TArray<TValidationResult>;
    function GetErrorMessages: TArray<string>;
  end;
  
  IValidator = interface
    ['{F1A2B3C4-D5E6-F7A8-B9C0-D1E2F3A4B5C6}']
    function Validate<T: TBaseEntity>(const AEntity: T): TValidationResults;
  end;
  
  TValidator = class(TInterfacedObject, IValidator)
  public
    function Validate<T: TBaseEntity>(const AEntity: T): TValidationResults;
  end;
  
  // Atributos de validação
  ValidateAttribute = class(TCustomAttribute)
  public
    function Validate(const AValue: TValue; out AErrorMessage: string): Boolean; virtual; abstract;
  end;
  
  RequiredAttribute = class(ValidateAttribute)
  public
    function Validate(const AValue: TValue; out AErrorMessage: string): Boolean; override;
  end;
  
  StringLengthAttribute = class(ValidateAttribute)
  private
    FMinLength: Integer;
    FMaxLength: Integer;
  public
    constructor Create(AMinLength: Integer = 0; AMaxLength: Integer = MaxInt);
    function Validate(const AValue: TValue; out AErrorMessage: string): Boolean; override;
  end;
  
  RangeAttribute = class(ValidateAttribute)
  private
    FMinValue: TValue;
    FMaxValue: TValue;
  public
    constructor Create(const AMinValue, AMaxValue: TValue);
    function Validate(const AValue: TValue; out AErrorMessage: string): Boolean; override;
  end;
  
  RegexAttribute = class(ValidateAttribute)
  private
    FPattern: string;
  public
    constructor Create(const APattern: string);
    function Validate(const AValue: TValue; out AErrorMessage: string): Boolean; override;
  end;
```

### Segurança e Criptografia

#### 19. `core.orm.security.pas`
```pascal
unit core.orm.security;

interface
uses
  System.SysUtils, System.Classes, System.Hash, System.NetEncoding;

type
  // Atributo para marcar campos que devem ser criptografados
  EncryptedAttribute = class(TCustomAttribute)
  end;
  
  IEncryptionProvider = interface
    ['{A1B2C3D4-E5F6-A7B8-B9C0-D1E2F3A4B5C6}']
    function Encrypt(const AValue: string): string;
    function Decrypt(const AValue: string): string;
  end;
  
  TAESEncryptionProvider = class(TInterfacedObject, IEncryptionProvider)
  private
    FKey: TBytes;
    FIV: TBytes;
  public
    constructor Create(const AKey, AIV: string);
    function Encrypt(const AValue: string): string;
    function Decrypt(const AValue: string): string;
  end;
```

### Operações em Lote

#### 20. `core.orm.batch.pas`
```pascal
unit core.orm.batch;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  core.db.connection.intf, core.sql.entity, core.orm.dialect.intf;

type
  IBatchOperations = interface
    ['{B1C2D3E4-F5A6-B7C8-D9E0-F1A2B3C4B5C6}']
    function InsertBatch<T: TBaseEntity>(const AEntities: TObjectList<T>; ABatchSize: Integer = 100): Integer;
    function UpdateBatch<T: TBaseEntity>(const AEntities: TObjectList<T>; ABatchSize: Integer = 100): Integer;
    function DeleteBatch<T: TBaseEntity>(const AEntities: TObjectList<T>; ABatchSize: Integer = 100): Integer;
    function ExecuteBatch(const ASQLs: TArray<string>; ABatchSize: Integer = 100): Integer;
  end;
  
  TBatchOperations = class(TInterfacedObject, IBatchOperations)
  private
    FConnection: IFUPConnection;
    FDialect: ISQLDialect;
  public
    constructor Create(AConnection: IFUPConnection; ADialect: ISQLDialect);
    function InsertBatch<T: TBaseEntity>(const AEntities: TObjectList<T>; ABatchSize: Integer = 100): Integer;
    function UpdateBatch<T: TBaseEntity>(const AEntities: TObjectList<T>; ABatchSize: Integer = 100): Integer;
    function DeleteBatch<T: TBaseEntity>(const AEntities: TObjectList<T>; ABatchSize: Integer = 100): Integer;
    function ExecuteBatch(const ASQLs: TArray<string>; ABatchSize: Integer = 100): Integer;
  end;
```

## Fase 5: Documentação e Finalização

### Exemplos de Uso

#### 21. `examples/basic_crud.pas`
```pascal
unit examples.basic_crud;

interface
uses
  System.SysUtils, System.Classes,
  core.db.connection.intf, core.db.connection.firedac.base,
  core.orm.unitofwork, core.orm.repository, core.orm.entitymanager,
  core.orm.logger, core.sql.entity, core.sql.attributes;

type
  [Table('customers')]
  TCustomer = class(TBaseEntity)
  private
    FId: Integer;
    FName: string;
    FEmail: string;
    FActive: Boolean;
    FCreatedAt: TDateTime;
  published
    [PrimaryKey([TPK.Create('id', tdInteger, Always, AutoInc)])]
    [Column('id', tdInteger)]
    property Id: Integer read FId write FId;
    
    [Column('name', tdChar, 100, 'Customer name', [doAll], [NotNull])]
    property Name: string read FName write FName;
    
    [Column('email', tdChar, 100, 'Customer email', [doAll], [NotNull])]
    property Email: string read FEmail write FEmail;
    
    [Column('active', tdBoolean, 'Customer status', [doAll])]
    property Active: Boolean read FActive write FActive;
    
    [Column('created_at', tdDateTime, 'Creation date', [doInsert])]
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
  end;

procedure RunBasicCRUDExample;

implementation

procedure RunBasicCRUDExample;
var
  Connection: IFUPConnection;
  UnitOfWork: IUnitOfWork;
  Logger: ILogger;
  EntityManager: IEntityManager;
  Customer: TCustomer;
  Customers: TObjectList<TCustomer>;
  I: Integer;
begin
  // Criar conexão
  Connection := TBaseFireDACConnAdapter.Create('MyConnection');
  
  // Criar logger
  Logger := TLogger.Create('orm_example.log');
  
  // Criar unit of work
  UnitOfWork := TUnitOfWork.Create(Connection, Logger);
  
  // Criar entity manager
  EntityManager := TEntityManager.Create(UnitOfWork, Logger);
  
  try
    // Iniciar transação
    UnitOfWork.BeginTransaction;
    
    // Criar novo cliente
    Customer := TCustomer.Create;
    Customer.Name := 'John Doe';
    Customer.Email := 'john.doe@example.com';
    Customer.Active := True;
    Customer.CreatedAt := Now;
    
    // Persistir cliente
    EntityManager.Persist<TCustomer>(Customer);
    
    // Commit da transação
    UnitOfWork.Commit;
    
    // Buscar cliente pelo ID
    Customer := EntityManager.Find<TCustomer>(1);
    if Assigned(Customer) then
    begin
      Writeln('Cliente encontrado: ' + Customer.Name);
      
      // Atualizar cliente
      Customer.Email := 'john.updated@example.com';
      EntityManager.Persist<TCustomer>(Customer);
      
      // Buscar todos os clientes
      Customers := EntityManager.FindAll<TCustomer>;
      try
        Writeln('Total de clientes: ' + IntToStr(Customers.Count));
        for I := 0 to Customers.Count - 1 do
          Writeln(Format('Cliente %d: %s (%s)', [I + 1, Customers[I].Name, Customers[I].Email]));
      finally
        Customers.Free;
      end;
      
      // Remover cliente
      EntityManager.Remove<TCustomer>(Customer);
    end;
  except
    on E: Exception do
    begin
      UnitOfWork.Rollback;
      Logger.Error('Erro no exemplo CRUD', E);
      raise;
    end;
  end;
end;

end.
```

#### 22. `examples/advanced_queries.pas`
```pascal
unit examples.advanced_queries;

interface
uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  core.db.connection.intf, core.db.connection.firedac.base,
  core.orm.unitofwork, core.orm.repository, core.orm.entitymanager,
  core.orm.querybuilder, core.orm.logger, core.sql.entity, core.sql.attributes,
  examples.basic_crud;

procedure RunAdvancedQueriesExample;

implementation

type
  [Table('orders')]
  TOrder = class(TBaseEntity)
  private
    FId: Integer;
    FCustomerId: Integer;
    FOrderDate: TDateTime;
    FTotal: Currency;
    FCustomer: TCustomer;
  published
    [PrimaryKey([TPK.Create('id', tdInteger, Always, AutoInc)])]
    [Column('id', tdInteger)]
    property Id: Integer read FId write FId;
    
    [Column('customer_id', tdInteger, 'Customer ID', [doAll], [NotNull])]
    property CustomerId: Integer read FCustomerId write FCustomerId;
    
    [Column('order_date', tdDateTime, 'Order date', [doAll], [NotNull])]
    property OrderDate: TDateTime read FOrderDate write FOrderDate;
    
    [Column('total', tdReal, 10, 2, 'Order total', [doAll], [NotNull])]
    property Total: Currency read FTotal write FTotal;
    
    [ManyToOne('TCustomer', '', 'customer_id')]
    property Customer: TCustomer read FCustomer write FCustomer;
  end;

procedure RunAdvancedQueriesExample;
var
  Connection: IFUPConnection;
  UnitOfWork: IUnitOfWork;
  Logger: ILogger;
  EntityManager: IEntityManager;
  QueryBuilder: IQueryBuilder<TOrder>;
  Orders: TObjectList<TOrder>;
  SQL: string;
  Params: TDictionary<string, TValue>;
  I: Integer;
begin
  // Criar conexão
  Connection := TBaseFireDACConnAdapter.Create('MyConnection');
  
  // Criar logger
  Logger := TLogger.Create('orm_example.log');
  
  // Criar unit of work
  UnitOfWork := TUnitOfWork.Create(Connection, Logger);
  
  // Criar entity manager
  EntityManager := TEntityManager.Create(UnitOfWork, Logger);
  
  try
    // Criar query builder
    QueryBuilder := TQueryBuilder<TOrder>.Create;
    
    // Construir consulta
    QueryBuilder
      .Select
      .Join<TCustomer>('c', 'c.id = o.customer_id')
      .Where('o.total > :minTotal')
      .AndWhere('o.order_date >= :startDate')
      .OrderBy('o.order_date', False)
      .Limit(10)
      .SetParameter('minTotal', 100.0)
      .SetParameter('startDate', EncodeDate(2023, 1, 1));
    
    // Obter SQL e parâmetros
    SQL := QueryBuilder.GetSQL;
    Params := QueryBuilder.GetParameters;
    
    // Executar consulta
    Orders := TObjectList<TOrder>.Create(True);
    try
      // Aqui seria usado o EntityManager para executar a consulta
      // Orders := EntityManager.ExecuteQuery<TOrder>(SQL, Params);
      
      // Exemplo de processamento dos resultados
      Writeln('Total de pedidos: ' + IntToStr(Orders.Count));
      for I := 0 to Orders.Count - 1 do
      begin
        Writeln(Format('Pedido %d: Data=%s, Total=%.2f', 
          [Orders[I].Id, FormatDateTime('dd/mm/yyyy', Orders[I].OrderDate), Orders[I].Total]));
        
        // Demonstração de lazy loading
        if Assigned(Orders[I].Customer) then
          Writeln('  Cliente: ' + Orders[I].Customer.Name);
      end;
    finally
      Orders.Free;
    end;
  except
    on E: Exception do
    begin
      Logger.Error('Erro no exemplo de consultas avançadas', E);
      raise;
    end;
  end;
end;

end.
```

## Resumo das Novas Units e Classes

Este detalhamento apresenta as principais classes e units necessárias para implementar o cronograma proposto, organizadas por fase. A estrutura foi projetada para:

1. Seguir padrões modernos de ORM como Unit of Work, Repository e Entity Manager
2. Fornecer abstração adequada para diferentes bancos de dados
3. Implementar recursos avançados como lazy loading, cache e validação
4. Garantir extensibilidade e manutenibilidade do código
5. Facilitar testes unitários e de integração

A implementação deve seguir a ordem das fases do cronograma, garantindo entregas incrementais e funcionais ao longo do desenvolvimento.
