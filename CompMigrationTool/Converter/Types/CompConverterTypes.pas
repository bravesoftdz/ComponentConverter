﻿unit CompConverterTypes;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils;

type
  // DFM 파일 정보
  TFileInfo = class
  private
    FFilename: string;
    FPath: string;
  public
    property Filename: string read FFilename write FFilename;
    property Path: string read FPath write FPath;

    function GetDfmFullpath(ARootpath: string): string;
    function GetPasFullpath(ARootPath: string): string;
  end;

  // 변환정보
  TConvertData = class
  private
    FFileInfo: TFileInfo;
    FSourceDfm: TStringList;
    FSourcePas: TStringList;
    FConvertDfm: TStringList;

    // 분석 대상 컴포넌트 정보
    FCompName: string;
    FCompStartIndex: Integer;
    FCompEndIndex: Integer;
    FIsInherited: Boolean;
    // 분석 중인 폼의 이름(T 포함)
    FFormName: string;
  public
    property FileInfo: TFileInfo read FFileInfo;

    constructor Create(AFileInfo: TFileInfo);
    destructor Destroy; override;

    procedure LoadFromFile(ARootPath: string);
    procedure SaveToFile(ARootPath: string);

    property IsInherited: Boolean read FIsInherited write FIsInherited;

    property FormName: string read FFormName write FFormName;
    property CompName: string read FCompName write FCompName;
    property CompStartIndex: Integer read FCompStartIndex write FCompStartIndex;
    property CompEndIndex: Integer read FCompEndIndex write FCompEndIndex;

    property SrcDfm: TStringList read FSourceDfm;
    property SrcPas: TStringList read FSourcePas;
    property ConvDfm: TStringList read FConvertDfm;
  end;


implementation

{ TFileInfo }

function TFileInfo.GetDfmFullpath(ARootpath: string): string;
begin
  Result := '';
  Result := TPath.Combine(ARootPath, FPath);
  Result := TPath.Combine(Result, FFilename);
end;

function TFileInfo.GetPasFullpath(ARootPath: string): string;
begin
  Result := GetDfmFullpath(ARootPath);
  Result := Copy(Result, 1, Length(Result) - 3) + 'pas';
end;

{ TConvertData }

constructor TConvertData.Create(AFileInfo: TFileInfo);
begin
  FFileInfo := AFileInfo;

  FSourceDfm := TStringList.Create;
  FSourcePas := TStringList.Create;
  FConvertDfm := TStringList.Create;
end;

destructor TConvertData.Destroy;
begin
  FSourceDfm.Free;
  FSourcePas.Free;
  FConvertDfm.Free;

  inherited;
end;

procedure TConvertData.LoadFromFile(ARootPath: string);
begin
  FSourceDfm.LoadFromFile(FFileInfo.GetDfmFullpath(ARootPath));
  FSourcePas.LoadFromFile(FFileInfo.GetPasFullpath(ARootPath));
end;

procedure TConvertData.SaveToFile(ARootPath: string);
begin
  FSourceDfm.SaveToFile(FFileInfo.GetDfmFullpath(ARootPath));
  FSourcePas.SaveToFile(FFileInfo.GetPasFullpath(ARootPath));
end;

end.
