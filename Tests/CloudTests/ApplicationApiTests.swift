import XCTest
import JSON
import Vapor
import Foundation
import HTTP
@testable import Cloud

let access = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0OTA5NjA3ODMuMDEwNTEsInBlcm1pc3Npb25zIjp7Im9yZ2FuaXphdGlvbnMiOnsiMDExOTY5QzAtOTc2RS00NzI4LTlBREQtOEU3MEZENEFCOEExIjpbXSwiMDQ1MDhFMkQtNEVDOC00QjA2LTkyNjAtODI2QzYxNDZEMDUyIjpbXSwiMDRBOTg3N0ItOEI1NC00NkQwLUE4Q0UtNDNERjc4MEY4MTlBIjpbXSwiMDRBQzk1RUQtRjA5QS00MjVBLThBRjctNjBBRkM5RTRERkIwIjpbXSwiMDVCQkY4NDktNUQ5RC00RERELTlDRTUtRUM0QjlDMjVGOTMyIjpbXSwiMDVFMzY5MzItOURBQi00MTlBLTgzNkItNTgyNEQxOURBQTBFIjpbXSwiMDY2N0U1NEUtOTQwQS00OUZCLUFGNTYtRjZDOUVFOTUwQkExIjpbXSwiMDc3RDIxMzUtQjVBOC00QTBBLTg0QkUtN0EwMkQ2Q0YzMTFGIjpbXSwiMDhCRDVDNDktRjExQS00NDdGLUFBMTktNjFGRDczRTA3RUUzIjpbXSwiMDhGNUY5OUUtNTgwMC00RjlGLTgwRjQtRUM2NTAyNDUzRUNFIjpbXSwiMDlBQjM0RUQtRTdBRS00Q0FFLUE0NTUtOTgyNjBDMDVDQzQwIjpbXSwiMEI2Qzc5NzEtMjQ1MS00RkNGLUEzN0QtNjg5Rjc2OEE3QUUwIjpbXSwiMEI3OUVBQUMtRjdERS00NTc5LUJCQjctMTRDNzJDMUE3M0U0IjpbXSwiMEJCRUM2RkEtRDFFMC00MTU3LUJFQzktQUY1NkM5MkMyOTkxIjpbXSwiMEMwQjk5NEUtMDQ5Ni00Q0U5LUE1QjgtMDEwRTY0MjFCREU1IjpbXSwiMEQzMkE5MTQtMjA5NC00RkM3LUI3MjgtMzQ4MDQ0RUVBNUIxIjpbXSwiMEQ5RUJFRjktMzZBRC00ODM2LUFDREMtMjc5NTFDMUUzNzcxIjpbXSwiMERFNjBBNTgtRTc5Mi00QkFDLTg2ODItNTVDNEI1MjUzNjA3IjpbXSwiMEUxNjM1RjYtNkYxRi00ODI3LUEyOEMtNkNDRjREMTg1NTIwIjpbXSwiMEUzNDZENjYtRTk5OS00MDFGLTkyQzAtMDFCNDNGQjBFRjczIjpbXSwiMEVDRUFGMDEtRUVCNi00MEY1LUE4QzItQTcxMjYxQzcyQTcxIjpbXSwiMTBBNDhDQ0ItNzhFOS00Q0EzLUFEMUQtMTVFMjk0MEY1OTYzIjpbXSwiMTBGMzdDMUMtQzg2QS00RDg3LUE5RTUtNUNGMjhDRjMwN0Q1IjpbXSwiMTFDNTM3RkItRDg2Ri00NUIxLUJEQUMtNzNBOTU0QjdDOEQ4IjpbXSwiMTIxMzMyNjktN0E3OS00OTgzLUEwRUEtRTc4MDk4MkZEMzQ1IjpbXSwiMTIyRjMxMkYtODk1My00MDJBLTgxREQtNDE0RTI1OEU5Mzg0IjpbXSwiMTI4NUVENEItQzUzNC00Q0E5LUFFQTctRkRENkE1Mjg3N0E5IjpbXSwiMTQyN0VGNjctRDdBRS00MjdDLTgwQzYtRjY3N0RBMTcxQUEyIjpbXSwiMTQyRURFQzQtMUE0Qi00N0I5LTgwNDUtODNEMDE0MTE0NkQxIjpbXSwiMTU4NTZCNkYtMTc1My00QUIyLTlCNjgtQkI3MDc3Njc2QjNEIjpbXSwiMTVERUEwQjEtNUM2OC00MTAwLTg3QjMtRTlBNkZBMjQ2NUE5IjpbXSwiMTYyNUNCNDItOUQxRi00RjY2LTg1QjQtN0ZENkEzQjI5RUVFIjpbXSwiMTY4Q0VCMDUtM0Q1Ny00RDU5LUEzQTctRkVFNjRBM0E2RUI2IjpbXSwiMTgxODI2NjgtNDg1QS00MDE1LTk2NTAtODkwNjM4MEQ0MDY5IjpbXSwiMTgyNjZGRjYtNUVDNy00OUE3LUFENTctQjU1NUIzNDNFQjEzIjpbXSwiMTk0RTMyNTQtOENEQS00OTQzLTk4MDktMkM2QjRDMjEzNzg5IjpbXSwiMTk1NTMyOUYtNjc2NC00OTkzLUFCMUUtNkVCNjQ4MDVEQTBCIjpbXSwiMUEwMjJBQjItRjEyMy00MEU3LUFDMkItRUVGNkI3RDIzMUJBIjpbXSwiMUE2MjdEQzMtOTMwQS00RkJGLTg2RkUtOENBMUJEMDE0QTMzIjpbXSwiMUIyMkY3QkEtRUExOC00RkMyLTkyNzMtRkQ2MDM4NzM0NEI1IjpbXSwiMUIzNDU1NjktQTU4QS00RDFGLTlCMkItNzgyOTFCRDc2QzJBIjpbXSwiMUJCNDYxOTgtNTk0OC00RTlCLUE2M0YtNzVDNkE3QjgxOTczIjpbXSwiMUM5NTZDNzktNUIwNC00Njc0LTg2QTEtQzgzOEY1MEU5OUUxIjpbXSwiMUNFRTEyNjctRERBQS00NDBDLUI3ODQtNEVENzAzODUxRkU4IjpbXSwiMURGNTcxMTUtMTBGNC00RkI5LUI5RjUtQzA5QUEyNTdCREYwIjpbXSwiMUY3NEUyMDAtMDg0QS00RUFGLTlERTUtOEQzODQyNDk4RkQyIjpbXSwiMjA1RjA5MjgtRkU0MS00ODZGLTg1OTEtQkY5QTlEMzA4RUI5IjpbXSwiMjE4N0ZGNUMtNkRFNy00RUJDLUE2NTEtODM0RUI1MTQ1NkY4IjpbXSwiMjI5Rjc2QTQtRjAzNS00MTRELUI3MEUtQ0U5RkMwMTMzMUVGIjpbXSwiMjQ5NUJFRUQtNjJFMy00NzQ0LUI5QTUtQjZGQTg2NjI5RURCIjpbXSwiMjRDMzNDNzEtMTA1OC00M0FBLThCRTMtOTM5MEFCMjA5MEExIjpbXSwiMjYxMTI3NDMtRDhCNi00OTA5LThEQjAtNEU4RkJEQzgwOTUxIjpbXSwiMjc1NkMxMTQtODZFMi00MzRFLTkyMUQtOTE4MzU2QjBDQTZDIjpbIm9yZ2FuaXphdGlvblJlYWQiLCJvcmdhbml6YXRpb25VcGRhdGUiLCJvcmdhbml6YXRpb25EZWxldGUiLCJwcm9qZWN0Q3JlYXRlIiwicGVybWlzc2lvblVwZGF0ZSJdLCIyNzZCREY3Ny05NkM2LTQ0MTgtQUVDRi0yNjgzRjk5RjkzRkUiOltdLCIyOTI2QzM1Ny1BNkVBLTQxMUMtOURFRS02RDY3RTgwOEM4RkMiOltdLCIyOUY1NjMzNC1EOTI0LTQ2M0QtQThBNy0wMjFDNkQyRjg2ODIiOltdLCIyQzEyMUQ4Qi01MkNCLTRBODQtOTA0Ny0yNjg5NDY2Mjk3RkMiOltdLCIyQ0IyOTk2OS0yNUNBLTRGNjAtQjI0MC03RDMzNkU1MDJEMTciOltdLCIyRDU2QTRERS0wMzM1LTQzOTMtOUUyRi1EQjlFNzczOTgwRTUiOltdLCIyRDdGQTAxNC0yODQwLTRGREEtOTMzRS04MjVFRUEwNzNEQ0QiOltdLCIzMDE5MjJENi0yOUUyLTRCM0ItOTcyOS1GNEM4NDkzRDc3QjQiOltdLCIzMDQ2NjU2Ni02NTQ0LTQxOUUtQjExNS04RUIwNzMzMzU5RUUiOltdLCIzMEQ0QzI2Qi00QzU3LTQ1NkItODlFMC00RDMwRjhFNkJDRDIiOltdLCIzMTBGM0VGNC01NEVGLTQ3MjgtQTI0NC0xQUVFNTkwQ0M0RTEiOltdLCIzMTNBNzQ1My1CNjMzLTRCQkUtQTE1Ri04RTQxNDgxMjIwMzIiOltdLCIzMUE0RTBGQS0yQ0I3LTREODctQUM0RS00MDE0MDE3OTMzQjUiOltdLCIzMUYwNjAyRS03MEEzLTREQUItQkY4RS1FM0MwMDYyMUY1RTUiOltdLCIzMzQ1QTM5RS0wOUE2LTRGMDItOTg1QS0yMDcyRkMyNzRFOEQiOltdLCIzMzVBODc3RC05OTY5LTQ4MkQtQjAxMS0zRjgxM0Y1NjlGQkYiOltdLCIzM0NDN0I4Mi0wQjI1LTQ2REItQjY4Mi00MUYzQkRGQUFCQ0YiOltdLCIzNDkzQzdDQy0wM0JBLTQ5MjctQTlCNi1EMkQ0MjQwRTM2NTQiOltdLCIzNTE3NEQyNi0wRkFCLTREMTktOEMxNy04Nzc3QTA0MUUyRDEiOltdLCIzNTMzNjJGMi05MjI3LTRDOEMtQjA5NS0xMjA5QTA3RDU3QkQiOltdLCIzNTgzODA1Mi0xMkM2LTQ1NUQtQTlBNi05NzVENTJENjYxNzkiOltdLCIzNUMyREY5My05OURCLTRDNEUtOTg0OC1FMzg1MTc2NDlCMjMiOltdLCIzNjA1QUFBQy0wNkMxLTRBNTEtOUNBMi1BMjBFNzhBQ0ZBQ0IiOltdLCIzNjY3QjZGMi1FRjI4LTREOUMtQTE2Ni0wNkM3QTM5MjEzMDEiOltdLCIzNjk5RTFGMS1BREYyLTRBODEtODc1MS04MkZGNERGNjZENDQiOltdLCIzNkEzQ0E1Ni1ENzQ3LTRDMjUtOEFGNi03QTZGQzY4Njk1N0EiOltdLCIzNkY4Qzk0My0wOEY5LTQwMEQtOUIxNS04MTdFRDgwNzdCOEMiOltdLCIzNzE0RTAzMy04MjFDLTQ3RDItQTEwNC05NzA2NUY1NDdGRDEiOltdLCIzNzMzQTVDQi0yRkVGLTRBMzktOUM0Ny1GMUUzRjhEMDFGODkiOltdLCIzNzg5QjM3NC00OTlBLTRDNTEtQTQwNy00Q0VENzdCMzI2NEQiOltdLCIzN0Q5OUY3OS00RDk5LTQzNUMtODI1Qy0zQzgxMDE0MjZCQzMiOltdLCIzOEE4RjU0Mi1CRkJELTQ3NUYtQkEyNC1CMzlEQjNDMzFGQjQiOltdLCIzQTZFNTVBNC1FNjk2LTQ4NkUtQTYxQi1CMjhDQUUyQ0ZERjEiOltdLCIzQkFDOUQyQS0xRUJCLTQxNTItODMyMy01QjdFODg2NzlBREUiOltdLCIzQzUzMTk0Ri1FREYxLTREOTMtQkU5Qi00NkJDMzgxRUIyRUMiOltdLCIzRDVCMzVFRS1ENDQwLTRCNTktOTdERC00RjcyMzkwODgwODEiOltdLCIzRDdGNDJCQy1DNDhBLTRDQ0MtQUY1Ny00Q0JDRkFFNzU3NkUiOltdLCIzRTIzOEVGNi1ENEQ2LTQ2NjktQUJFNS03MEYwMjZGOUQ1QjMiOltdLCIzRjdEMkYyNS0zOTA3LTQ4MjItOEYwMS04QjgyRDA5NEYzQTkiOltdLCIzRkUzRTIzMy0wNDEyLTQ0NDUtQkJENi04MzI5MTQ4MDNEQ0MiOltdLCI0MDg0RUIxNS1BRjc4LTRCMTEtQjA4OS05MkUyMDZGRjg5RTYiOltdLCI0MEVBN0FFMi03ODM4LTQyNzEtQjI5Ri01OTgzRTE5QUFBOEUiOltdLCI0MUY1OUZDMS0xNDNGLTQwNEQtQTZENS1EMkQ4QzRCNzdBRkMiOltdLCI0M0Y1OTFFQi0xOEVBLTRDN0UtODkwRi03QjA0REM0RUExMDAiOltdLCI0NDk5OTA4My1BRTBFLTQxOTYtOTc4QS01QUY2QTUxMkQ1QzgiOltdLCI0NEFDQTkwQy1CQTE1LTQzOTctQTExNy0xQTE3QTJFNEE1OEYiOltdLCI0NEZGNUEzMy05QTU0LTRENTgtOTgyOC01NDA0M0JDODRCNTUiOltdLCI0NTIzMzBBNC1CQTU4LTQ2QzUtOUY2Qi03Njg0REM5MEQxMjUiOltdLCI0NTk5MjFBOC05OEU4LTQzNUMtOTEwOS03NThBM0QxMTBDNzciOltdLCI0NkE5MjU2MC1GQjQ4LTQ5RUEtOUYxRC0xQjI2QjM5MjJEN0YiOltdLCI0NzA0Mzg4My1DOTE5LTQyNTktODEzMy1GRDRGOUI1RjEzMzgiOltdLCI0NzIwNjVCRi1FOEQwLTRCOUItQUNFMy04QjJBOUY2ODc2OTMiOltdLCI0N0E0MTM3RC00RDYwLTQxMTYtOENGRS1DQTRFM0E4MjY0NzUiOltdLCI0OTJBMjg4NC04RjNDLTQyQTktQjRDOS1GOTdCMURGNTFCMDMiOltdLCI0OUE2RkY4OS1EQzJCLTQzMjAtODM5OC0wNzFDMEE2NTZDNUEiOltdLCI0OUJGNzc4OC1FMzkyLTQ3NDQtQTNFRS1GODFGNkFDM0Y5REYiOltdLCI0QTIwODdBRi04OTYxLTRERTYtODYzNS1GQUFDMEZEQjgyQ0UiOltdLCI0QUE4RjY3MS0yQkE5LTREMkQtOUM2QS00NzkxRDYwQTczNkEiOltdLCI0RjNENTU0RS1ENjM2LTRCRUQtQUZFRi1DMTE2RDI5RUU4MzkiOltdLCI0RjU1NzNDMS03RTNCLTQ3MDMtQkJDOC1CMTYyRDdDNzM4NUEiOltdLCI1MDcxQUVDOC1GQkM5LTRBMUEtQTE2My00ODRBN0ExQkVBQ0IiOltdLCI1MDdCQzVFQi05NTg2LTQ1RDYtODNGQi1CQTM3RjcxMzEwOTEiOltdLCI1MDlCODQxMi03MTRGLTRDMTgtQjQ5OC1FNUYzRDMyRUFGMzciOltdLCI1MEIwOEM5NS04OEQwLTQ3NkEtQjc2QS1GNTFDMkU3QzlBQTgiOltdLCI1MTdBODkzMi1ENTUxLTQ3MUItQTFENi05MzFFRDU2RUNBQjkiOltdLCI1MjREMjQxRi0wM0RELTQzODgtQjM2OC00Njc0MkU0OUM2NzUiOltdLCI1MjhCMEUwNC0yOUZELTRFREItQUQxNC1FNEEzMEYzNkNFQTIiOltdLCI1M0I3RUZFNC01RTc0LTQ3MzUtODc1Qi1FOTlFMTk0MTc5OUUiOltdLCI1NERBNUU3Ni1BQ0QxLTRGMkEtQTFENi05QUYxMTUxRTBCMjkiOltdLCI1NTYzRDUwMy02QTgzLTQ2OTUtODkyOC1DQzdEOEM5OUI4QkQiOltdLCI1NjIxODE0NS05MjBBLTRFQUQtQTIzOS02NTA2RjY2NDUwOUUiOltdLCI1NzJCOEU0Mi1CM0I1LTRFQzQtQUYzRS0wMUM2NENFNzVDRTUiOltdLCI1QUI3QUExOS0zNDBGLTQ5OTItOTI5Mi0yN0E1NTM0REEyRjEiOltdLCI1QjI0RjM3MC03MzI4LTRBNkQtOTI5Mi00QTBEMTY2MzAzMUIiOltdLCI1QjU2Mzg0RS1CNzIzLTREQUItQkE5MC00QzUzNUZGMkI3QjYiOltdLCI1QjhERDczNi1FNUU3LTQ1QTItQkY4Ri00N0VENzcwMkVDOTEiOltdLCI1RTUzMkQ0OC0wQzQ5LTQ0NjgtQkIzMi00RUZCNjlGNDA0NzUiOltdLCI1Rjc1OEE4NS0xQUY4LTQzOTItQThBRi0zMzgzQTdDMDU0OEIiOltdLCI1RkJFOThGRC05OTBFLTRDNTctQjRENC0yNzI4QTZBNzNGNUUiOltdLCI2MDBCODM1Qi00REJBLTRCOTItQUZFOS0xMTRBQUE3NkIzQTAiOltdLCI2MDVFM0I0RS0xMDYwLTQzMTgtQTM4QS0wOEZENjgxOERBNTgiOltdLCI2MTc3MDFBNS02MzlELTQyM0UtOUQ5Qi03RDI0QzVBNDc0RDAiOltdLCI2Mjg0NDdFQS02MDM3LTQyQ0YtQkE3OS1DMzAzRDgzMjNBRTUiOltdLCI2NDExNUZFOS02QUZDLTQ3QjYtQTVENS0yMTAwNzJBMjdDMkIiOltdLCI2NDIxNUQzQy0yMjgxLTRGRjMtODY2QS1CNENDOENDNjQyQjMiOltdLCI2NEYzQTZFOS1FNDkxLTQ3NkYtODI5RC1FOEMyNEUwNUM1N0UiOltdLCI2NjQ3QjIyQy1EMzM4LTQ3NDQtQUZGRS01NTNGMjhGQTVFN0IiOltdLCI2NjcyMTY0MS04OUY2LTQxMEEtODM2Qi0xN0IzRDI3MUEwRkUiOltdLCI2NkRENzQzQi05MzA4LTQyRDMtQUQ4My00MjY4OEYwMkY3MTgiOltdLCI2NkYxNTUxNi04NDE4LTQ1MjItQTcwNy0wQ0Y1MTVFRkU3RTgiOltdLCI2NzMxQjc5Mi1GRUJFLTQzRkYtODUxOS1DNzkyQzYxQTdDNEIiOltdLCI2NzQ2NTQ2Qi0xNTA0LTQyNEQtODdDNC0zMTRFRjVENkMwNTMiOltdLCI2ODBCNzlGRS0yOUMwLTQ0MDEtOTZEOC05MDEyMThGRkRENzMiOltdLCI2OUJGOEYxOC1CNTkwLTQ4MkYtOUQ1MC02N0YwQTdERTlBMTYiOltdLCI2OUM0NkE4RC02QkZBLTQ4MDktQkFENC1ENTY4QUUwQkMzNTEiOltdLCI2QUM5RjhCRS00RjlBLTQ2MkUtQTQ3MC1CNTk1MkUwOUYxMjYiOltdLCI2QjQ5MTQ1Ny05NUU4LTQxREQtOUM5MS03NUU0OEM2MUMwMjEiOltdLCI2QzE4MEY3Ri03QjkwLTQ3ODgtQjNFMC0wNjk3MTUwNjNFOTkiOltdLCI2QzUxQUU0My01NkEzLTQwMEMtQTNBQS1COEJDRjIwRjIzRkQiOltdLCI2QzUzOTdFQS01MjdGLTQ3QUYtODJEMy05QUU2RkExN0Y5RkIiOltdLCI2QzY5MzBCQy1GRTFGLTRDOTgtQTdGRC00ODYxMDFFQkJCOEYiOltdLCI2RDI0N0ZGOC01QUI0LTQ3OTEtOTBBQy0wMjUyNUIxODJEREIiOltdLCI2RDNGQjg0OS0wRTc0LTQ0NzctQTYxNi1GRDA0NkNFMUE3N0YiOltdLCI2RDgxRDI4Qy1DQkFFLTQ3QzktQkFBQi0xRTc3RkM5MTdFQTIiOltdLCI2RjM3MjVERi0yRkI5LTQ0OTItOTlDRi1GMzgwNkM0OTZDRjUiOltdLCI2Rjk5QUZBMy0zNDE0LTQzRDItQkIxNi0wNUI5NDU1N0IxNEEiOltdLCI2RkZDMTU0QS1FNDJDLTQ1RDUtQTkxOS1FQzlFQURCNDZGNjgiOltdLCI3MTQwMjY2RS1GQkJFLTQ5MzItODYzMC00NEE4NUEwNUMzMUQiOlsib3JnYW5pemF0aW9uUmVhZCIsIm9yZ2FuaXphdGlvblVwZGF0ZSIsIm9yZ2FuaXphdGlvbkRlbGV0ZSIsInByb2plY3RDcmVhdGUiLCJwZXJtaXNzaW9uVXBkYXRlIl0sIjcxQjAyNjE2LUU0MkMtNDE3Qy1BOTJFLUEwREMxRDEyNzlBMiI6W10sIjczQTFEM0ZBLUQ4RjYtNDRGMi1CNUQ2LUI0RDcxRUU5Nzk3RiI6W10sIjc0QzEzOEJELTY5NjktNDVGNS1CNjlBLUFFMEFDMTJCODIxQSI6W10sIjc0RUVFQ0ExLTZBMkEtNDE5My05OTA0LThGRDVGM0M1OERDQyI6W10sIjc2NEZFNjdGLUU3NjgtNDIyNS05NzU0LUIyMjQ1MzQ1NERERiI6W10sIjc2RTczQTg4LTIzNUYtNDg2Qi1CRTNELTVEQTIzQzNBREI4NyI6W10sIjc3OTc1RDQ0LUIyNkQtNDIxMC1CMURFLThCOTFCNThDQTgyNCI6W10sIjc3RDQ1NEU5LUE0QTAtNDhERi1CQTBGLTYyQzE3QTZGNTlFRiI6W10sIjc5OENBRjNGLUYxMzYtNDhCQi04QTE0LTk3RDREMThDRUY1NyI6W10sIjc5Q0MyODkxLUJBREMtNDVBMC05MUVGLTEwMDg5ODI5MTVDRSI6W10sIjdBQjFFNEM2LTU2MDgtNEYxMC04NzU2LTU3NzAxRDM1OTMxQSI6W10sIjdBRjhBNkNGLUQ2NEEtNDc5Ni04RDc4LTYxMTkzNUQxNEI1MyI6W10sIjdDRDI2MEQzLThFQjktNEUxMC1BRkQyLTFFRkIzRUI1RUNCMiI6W10sIjgxMEI3RjY1LTA4REEtNEQzRC05MzZGLTU0QTc0REJGMTYzRSI6W10sIjgxMzRGQTQ2LTRCN0ItNDM0RS04NEUzLTE2NUJGRTQ0ODVCMiI6W10sIjgzN0E2QkMzLThDQzEtNEYwNC1BNjUzLTQyRUFGNUUwRjIwOSI6W10sIjg0QUYzRjM4LTZFMDItNDIwQi1BQUVBLTVBNTUxOTlBN0M5NiI6W10sIjg1MjAxMUFELUNCQzAtNDkzNi1BOTEwLTY5RTFBNURBQTc3QiI6W10sIjg1OTZEQ0I5LTM0NDUtNDQ1Qy05QUY2LTJGRTJFNjdFRTJGQSI6W10sIjg2Mjk5NDdDLTNBQjEtNEM2MS1CMDEyLUYxRUI2QzU5RDk0RiI6W10sIjg5NDQ3MDc3LUUwNzgtNEQyMy05REMzLTkyRjA5NTEwODk1NyI6W10sIjg5QzVBOUExLTg5M0EtNDZDNi05QTVCLTBGRjZERTZFOTg2RiI6W10sIjhBMUJGNzhGLUU5MEUtNEU5RC1CQjY3LTRGRTMyMjlCMzAxNyI6W10sIjhDNDM3NTA0LTQ1RjMtNDk5QS04NjNCLTBGMzVBNjgwRUE1QyI6W10sIjhENUQyQTNCLTc2Q0ItNDdGRi1BRjM5LTQ2RDMxNzVFQjIxQSI6W10sIjkwM0E5NTYyLUQzNDUtNDk5MC1BQTA0LTVCMTlBOEVENTJFNSI6W10sIjkwQ0VGMDM3LTg3M0EtNDQ3RS1BRTMwLTUwRkE3M0E4NDhEMSI6W10sIjkxRUJBQTA1LUY2MUEtNDY3RS1BRDk3LTk4Qzk0NjkxMzU1MyI6W10sIjkxRUVGQzlBLUQ5RDItNDY0Ny05OEMxLUVBQUFFQUQ5MkY2RCI6W10sIjkyODI0RENFLTZCMjgtNEZCNS05MjM5LUMwRDg1NzhDQkQyQyI6W10sIjkyODMyOEFFLUM2RDEtNDMzRS04OUMzLTJEM0MwMzEzRTk4RCI6W10sIjkzMjQ2MzEyLTdCMTAtNDFCQi1BMDVCLTcxMzFGNDJENzM1NCI6W10sIjkzM0EzNEQ1LTFCQzMtNDc5MS05ODdFLTg0NjFBRUVCM0Y2NSI6W10sIjk0MzExRUI2LTNGNkQtNDZGNC04NzFCLTE1NURCN0NGNTRFNCI6W10sIjk0NDY2QjZFLTYzQkQtNEYwOC05M0UyLURDNkJFMjZFRjRERSI6W10sIjk0RDdEMDU0LTU1M0UtNDMzRC1CRkZELUZCMjYxRkNBQjYxMCI6W10sIjk0RTcwNUM0LTZBODEtNEFCNi05N0FGLTBBMkRBRTQ0MjBDRSI6W10sIjk1NjEwREFFLTJERjctNDcxMS1BODY2LTFCRENCNTBDRDBCMiI6W10sIjk2NjMwRjMwLTYwOUYtNDgwQS04NDVDLUU1NTFBQUExQkZFOSI6W10sIjk2QUZENEQ0LTBFNjItNEE0Ri1CMzk2LTM5QzU2MzgzNkI1MyI6W10sIjk3OUVFRjUzLTdCOEQtNEY5Ni05RDg2LUM3RjQ4N0UyODQyQyI6W10sIjlBOTE0MzNGLTZBNzktNDRCMy05RUJBLTAxQUE3MzdFOTE2NCI6W10sIjlBREI1NjAzLTY4NTAtNEZEOS1COTc0LTU0RUUyQUQxNTQ0MiI6W10sIjlCOTg0RjcxLTlDRTYtNDQ2NS1BMzcyLTQ2NURFQjEwQTMyNyI6W10sIjlCRTZCQURFLTE2MTQtNEZDRC05OTY4LTMyRDA4RDdCQUFCRiI6W10sIjlDQTBEMkNDLUQ2MjQtNDUxMC1BNDY0LTczNzMyREFCRjdENSI6W10sIjlEMzE3NjMzLTY2NzUtNEIxRS1BRjYyLUM2OTM0NDI5RTg5MyI6W10sIjlERkU0OUFELUIyOTItNDBDQi1BMzMxLTdGQ0I1RDkxOTkyOCI6W10sIjlGQzU3MDIwLTA3NTgtNEMwNS1BRDc4LTM1ODIwQzBGODIwRSI6W10sIkEwQjdGMDU3LUI4OTUtNEVDQi1BNTJFLUY4NEU3MEY1MTNGNyI6W10sIkEwRDc2Nzc3LTYyMEQtNEM5NS04NDUyLUY5Q0IzRERDNDNCQyI6W10sIkEyQTYwN0RCLURFMjUtNDQ5OS1BNzA2LTQ2QjI4N0RDQ0IwRSI6W10sIkE0NDdEMTMzLTNCMTgtNEE2Qy1CQjZBLUI1OTBBRTg0MzhGNCI6W10sIkE1NjY0NEJELTRERTYtNDA5Ri1BQTJELUZCQ0U4MzJGQjdERiI6W10sIkE1Njk1ODM2LUJDREYtNDg2Mi1CRkZBLTk4Q0U1NDE3M0E0RCI6W10sIkE1RTYyQ0Q0LTE0NTctNDVCOC05NkE3LTcxMjAwNDFGM0YxMiI6W10sIkE2MENDMTNCLUZEMjItNDdEQi04QjRFLUJCM0FENDIwQzMxQSI6W10sIkE2Q0FCOEJGLTlBOTktNDg4RS1COUJBLTE2OENGQUY1OTM0MSI6W10sIkE3RkMyRkNCLUFGODktNDU5RS05Q0EyLTE3ODEyOTE1OUMzNyI6W10sIkE4QTYxRTVELUVGQjQtNEIwNi04QzhBLUQ4RTE1RjI2NzQxQiI6W10sIkE4QTc3MkYyLTcxMjQtNDY0Mi04MjY1LThGNURDMDMyQjU3MiI6W10sIkE5OEIzOTM4LUYzMUYtNDJGOS04NkZGLTQ0MkYxQ0JGOUFBNSI6W10sIkE5QjYzMjVFLTEyQUItNEFFNC1CMTBCLUMxRTc3NzZFREIxQSI6W10sIkFCOUJCOURELTZEOTktNDBDMy05MzQ0LUM3MDNERkY2NzA4NSI6W10sIkFCQjc1OERDLUM2MEYtNDU0QS1BQUY4LUU5NUI1NEU1MTFGMSI6W10sIkFCQ0ZFNkYyLTA4MzUtNDk2MC05RjM5LUUyQjExQzM2MDZCQiI6W10sIkFDMTUyOERDLTc5MzAtNDBFMy1CNTA0LTg3MkVCNDU0NUZEOSI6W10sIkFDOERDQjYzLUNENjEtNDY4OC04MEY5LUFDNUJENzRFODM2RSI6W10sIkFDQTFCQjY0LTZDRUItNEM3My04NDhELTk4MjlDOTI1Q0M0RSI6W10sIkFFMEY3OEEwLUM0QUMtNDBBOC1BM0UxLUNBMzgyOTNFMDQxNiI6W10sIkFGMUI2NjMwLUFBOTAtNEU1My1BODBELUQ3QTAyRjhDN0ZGQyI6W10sIkFGNDE4OENCLUI5OTctNEQzMy04MTVGLTE2MDBDNEUxN0YwMiI6W10sIkFGNjlGMkY2LUNGN0ItNEFBMi04REM0LTQ1Q0Y4RTQ4N0JFQSI6W10sIkFGRjNEOUExLTNGNTEtNDU5MS1BQzIwLUFBOURGMkY5OTQ5MiI6W10sIkIyQzMxOEQ1LTNFRjQtNEUxMC1BOURFLTQ2NzZFRUI0RDM5MiI6W10sIkI0MkM2OEZELTg4MkQtNEU2MS1BRjgyLUJGNzEyQjMwQjM4NiI6W10sIkI0NDFDMjhBLTE2RDgtNDU1MC1CQkI1LTE5NjdENDdBODAwOSI6W10sIkI1REZEQkRELTVDNUQtNDczNC1BM0I4LTNBNEFFQ0RENzNDOSI6W10sIkI2QjYyMzUzLUEyMTAtNEUxRi1CNkQwLTA3QzE4REI0REJBQyI6W10sIkI3MkJGQUU0LTA5RjItNDJFNC05MkZCLTUwNUI0NkEyODhEMCI6W10sIkI4RDJERDZDLTFFMkEtNDBCNC04QjJELURCNzFBQzdCQkEzQSI6W10sIkJBNThEREUyLUQ1MzAtNEIwQS05MTExLTAyOEY2MTcxRjAwRSI6W10sIkJBOUMzNzA5LTYwMzktNEY1My05MEU1LUQ0OUQzNkQzRTc3NiI6W10sIkJBRDgwRTMwLTFDNTAtNDZBRC04NEVGLTI1QzFFM0Y1NkI1MSI6W10sIkJDNTBCMjFGLTdBRTctNDUxRS1BRTVFLTE5RTRFOUMwNjA2QyI6W10sIkJDQzVFMTRBLUQ0MjEtNEEzMS04NDQ5LUVCRDE1Qzc1RDVGRSI6W10sIkJEOUEyRjZELTk0QjYtNEJDNC05NjIyLUQ5RkQ2NjU1RjY2MiI6W10sIkJEQjkyNDIzLTAyQzktNEVCMy05Q0JCLTc5QTUzNTAzQzAxNCI6W10sIkJFRTEwQkMwLTY5QjUtNDlDNy1BNDgyLTcyRjhBN0JGMEI4RCI6W10sIkMwNjlDNjgwLTMwMDAtNDZDRS1BOUNCLUI5MTM5MjM3OTFDMiI6W10sIkMwRTVCMkNDLTY3QzEtNEVDRi05ODVGLTQ0NUQwQjg5RUU1OCI6W10sIkMxRDAwM0MwLUYxMEYtNEE0MS1CQzIwLTFEOUE5QzAzMjkyQiI6W10sIkMzQUMyMzIyLTM1MTUtNEE0MC05N0I4LTNDNENCRTAzMkExRiI6W10sIkM0MzU0QUJDLUNDQUQtNDI5MC04QjdBLThEMEEyOTZDRTYyNyI6W10sIkM1MEZFNEZDLTFBMTMtNEMxOC1COTRCLTQ2NjNEM0JCNkRCOSI6W10sIkM1QzdBMzJCLTNDQzItNEMzMS1BMERCLTE5NjREODRDMTRCNSI6W10sIkM2MDcwQkRELTdEMDUtNDlFNy05RDVELTQyOTNGNDQ4RjZBRCI6W10sIkM2MDk5MUNELURGRkItNEMzQy04RUIxLTQ5ODQ4NDNDQzI3MyI6W10sIkM2MjcxRkVFLTRCMjctNDUzRi1CMTRCLTIwQTdCNzFCMjAzNSI6W10sIkM2NEU2QzM1LTYxOUItNDAyRC1CMDg2LTRENkE4M0UzNEVEMCI6W10sIkM4MEY5QjRFLTIzM0ItNEI1RC1CMDJCLUQ5ODMzQTlGMkVCNiI6W10sIkM4M0QwQjIxLTM1MzQtNDM4NS04QTVELUEyODJDQzk0QjA0OCI6W10sIkM5NkMxNTdBLUU5QjEtNDlGQS1BNzg0LTkxMjRFN0E3NEZCMCI6W10sIkM5REFFRkMxLTAzMkEtNEI3NC1BRjEwLUZGRTk0Q0JFNDU4MyI6W10sIkNCNjIxRkFGLTY1M0ItNEE1Ri05NUEzLUU0Q0I4NDYwMzY4OCI6W10sIkNDRTI2MkE5LTUwMTgtNDI3Qi05RTNDLTlBODY5MDU3MUM1MiI6W10sIkNEOUIxQzgyLTgxQjEtNDFDRC1CQTkzLTIyMzVBM0JBRTI4MiI6W10sIkNEQUEzNTBFLTQyMTAtNEJCRS1BMzlFLUY2NzQ4MEZBQURBMiI6W10sIkNFMzBBQzZCLTZCRjgtNDM5RS1CNUMyLUVCRDJBNUY1QTJDRSI6W10sIkNFM0U3MUY4LUQ0NEQtNDIyQS05NjcxLTczRUM1RjFDMUIyQiI6W10sIkNGMTVDNDdFLUUxRUItNDM2My05M0U5LTAzNTAyQzk2QzM2NCI6W10sIkQxQzRCNEU4LTZGQTYtNDIzQi05NEIyLTNFQUM3NDJCREVFNiI6W10sIkQxREIxNjYzLTBGNjItNENERS1CMDAxLTYwQ0UzOEJERUNBQiI6W10sIkQyQkYzMTY5LTkxQUUtNEQ4Qi05RTFELUQ3ODMyRDg2Rjc2RiI6W10sIkQ0ODJFQzgzLTc1MDEtNDIzNy05QkI3LThBOUNGOUUzN0RGNSI6W10sIkQ0QjU3MERGLUFCNjQtNEUxQi04NzlFLTBDNkFBNzBBODFFMSI6W10sIkQ1QTkzQkU1LTc0MkQtNDQ0QS1CQTRFLURBRDEzNjNBQzg0MSI6W10sIkQ2REZGMDAwLUNEODEtNDJENS1CNzNDLTFDOEJBMDBDMTE2RSI6W10sIkQ3MjQ2Q0UyLTQ5RUUtNENFRS05QkJGLUIzM0MwMzAwN0IwOSI6W10sIkQ3NzIyOTZBLTBGMTgtNDk3OC04Mzc3LTk0NjU2MTRFMDBGOSI6W10sIkQ3RTlCRkRDLTNDREEtNDZGNC04MUQ1LTVGOUM3NjBBN0UwMSI6W10sIkQ4NzVDRkEzLTJEQTItNDU3My1CNDVCLTE2NEFGRTdGNkFCNyI6W10sIkQ4ODQ3MEM2LThFREEtNDA0OC1BNUYzLUQ0RDQxNzJDMTgyQSI6W10sIkQ4OTc2OEI1LTc0MjMtNEQxMC1BNUU1LTU4ODVDRkE2QzgyMyI6W10sIkQ4RkYwOEM5LUIyQUUtNDVDNy1BNTk0LTU5MDk1OEZDRTg1MiI6W10sIkQ5NDExMTUzLUEwRTEtNDU0Qy05ODg3LUNBNTJFN0VBQUQwQSI6W10sIkQ5NzJBNTVBLUYxNjEtNDA0RC1BNEEyLTlDREUyRjhERUQwNSI6W10sIkQ5QzA2QUJELTFFQjgtNEY5NS1CRUJGLUY0OTkwQzY1OTE1MyI6W10sIkRBRTEyQUI0LTg4RTItNDQzNy05MzBCLTc2MzM2Q0I3RjA1MSI6W10sIkRFMUQ3RjJFLUNBRkItNDExMS05QzY1LTk3MDlCQzhEODhEOCI6W10sIkRFNjg1MUJGLUUzMDctNDM2MS05Q0Y5LTVFQTJEMzU5NkY4NCI6W10sIkUxNEVGNEE4LTAzMUItNDcyRC1BMjY5LTNEQ0FFREIwQzZENCI6W10sIkUxRTI0MTRCLTJFQjItNDVDNC04MjFFLTA0MzkwMUEyOTUxNiI6W10sIkUzNEUzRDAyLUI1MkUtNEVBQS1CMTFDLTZCOTU4QTJFRDY3RSI6W10sIkUzNUVCOUEyLTU2RkEtNEI4RS1BREI1LTE5M0JBQ0VCREI0NyI6W10sIkU2MUYxRUIyLTdDNDktNDlEQy1BODk0LTBBNDBBRDgxRUJFRiI6W10sIkU4MDY2MUZGLUM1RDItNDRFMC1CQzAzLTcwNUE1MTc5NThGNyI6W10sIkU4MDlEMkQxLTkwNTctNDBFMi05Nzc2LTFBQjQ1NTFDMjMyNSI6W10sIkU5N0NDMzUzLUY5QTctNDQzOC1BQjBBLTE1OTY4OTlDRTlDRiI6W10sIkU5RUYyNjAzLUVFMjgtNDRGQS04NzgxLTAxMDBCNUEwM0U0NiI6W10sIkVBMTgzRkFFLTYyNzYtNENGOC05QzIwLUNBQzQzQkFDNzM3QiI6W10sIkVDRUYyMDAzLUU5QUItNEVGNi05RTY4LTM5RjM2RDRFOEZFMiI6W10sIkVDRjQ5NUNGLTIyODUtNDRFMy1CNzQ5LTA4N0NBMkRFMDk3NyI6W10sIkVEMDNEMDBBLUY0MzctNEVFQS1BQkFCLTkwOTRCQzQwNzg3QyI6W10sIkVENEQzMERGLTdFQzItNEYyRi1CMjgxLUYwNUY4N0M4NzEwQiI6W10sIkVERDRDQjAzLUM3RTItNDEwMS04RTkwLUQ5NUIwMTg4MzA2OSI6W10sIkVGOUI3NkExLTI3NTAtNEE0Ri1BQzZCLTNCRUE4MkUzNjkxMiI6W10sIkYxRjk3MEQyLTFBOEEtNDg4MS1BMDAxLURFOUE5RTg5RDUzNSI6W10sIkYzMjhCQTlCLTVCOTYtNEM2QS04MERCLTVERkU0NzdBQkRDNSI6W10sIkYzNzcwMTg5LUM0MjQtNDc3Ni05Nzk1LTIzNjE5MTg1RUM0RSI6W10sIkYzQkYzOEJFLUQ5QkMtNDg1Mi1BNTM4LTBFRUQyOEE3MzAzOCI6W10sIkY0NjFFRkVCLTAyQ0EtNEI1OC05NzhELUM1REM0NjI1M0QxQyI6W10sIkY1NEFGOTJGLTY4MzUtNEZCRC05QzlGLTJFQjlCMjM1MkZGMyI6WyJvcmdhbml6YXRpb25SZWFkIiwib3JnYW5pemF0aW9uVXBkYXRlIiwib3JnYW5pemF0aW9uRGVsZXRlIiwicHJvamVjdENyZWF0ZSIsInBlcm1pc3Npb25VcGRhdGUiXSwiRjY3MjlCQjItOTk3MS00NDI2LTgyRjYtNTVDNDYyM0MxQzI3IjpbXSwiRjgxNTk0OTctMkMwMy00OTE1LTk1MjMtQzM3RkIwQkJFNUU1IjpbXSwiRjhBRDEzMkUtNTZGMy00QjJDLTg4NUUtQUFDNDNDNDc4RTU3IjpbXSwiRjkwODBBMjUtQTI0QS00NjAyLTk0REMtNEMxNDg1QzkwNjExIjpbXSwiRjk2RTQwOTYtMEUyMS00Q0U2LTlGOEItMUQ2MjRBN0MzOTI3IjpbXSwiRkE5NTYwMEYtNERFMS00MzUxLUI0NDUtMTNCNERBNzhFQTBFIjpbXSwiRkJCMjMwNjAtM0M5Ni00Rjc4LTg2QzYtQ0Y1NjMxNDNGQjUwIjpbXSwiRkJEODMzMjYtQTA2Qy00ODM3LThBMTAtNjEwMzQyNDQ3QTM2IjpbXSwiRkJEQjBCNkItNjY1RC00MkQ2LTlBM0MtOTA5RTYyQ0E3NzEyIjpbXSwiRkNGMzIyMDItRUU2Ni00ODM5LUI4RjItNDFBRDQ2QjFGMDY4IjpbXSwiRkU4RjM3MkEtNjE2NS00QjIwLTkwM0MtREY0MkU3QzU5NkQ3IjpbXSwiRkY4NUMxN0YtRTE0Ny00MjY1LTk1REUtRjhFRkQ2RkNGRjlBIjpbXSwiRkZBREU1QTktOTMwNS00NTcxLTlCRDgtMEUwRjE4ODUzRjNCIjpbXSwiRkZCQUJFNEUtRjI1RC00MUQzLTg2ODktODJBODI2MTM0NDRBIjpbIm9yZ2FuaXphdGlvblJlYWQiLCJvcmdhbml6YXRpb25VcGRhdGUiLCJvcmdhbml6YXRpb25EZWxldGUiLCJwcm9qZWN0Q3JlYXRlIiwicGVybWlzc2lvblVwZGF0ZSJdfSwicHJvamVjdHMiOnsiMDA3Q0RBOEUtMzZENy00RDNELUEwQTAtNUE3RTlFNTRFMEVEIjpbXSwiMDQ2N0QwMjMtRjY5QS00MjQ1LUI3RjAtNzUyM0NBNkFEMURCIjpbXSwiMEMzMDI0QjItNkRCRC00M0FBLUE5NkMtQ0VERUZENkI5QkVCIjpbXSwiMEREMjc3NTEtMENCQi00NTQyLUI4QzItMkQ2QUNFMTE2NzAwIjpbXSwiMTA1OUVEOTItOTFENC00OEY3LUFDNUQtRkZDNjc3OEE4RTc2IjpbXSwiMTI3NzgwNzAtNTIzNS00NDQ4LUExMUEtNUQ0QzQ3OUIxMTFEIjpbXSwiMTJCNDYzRjMtOEI2OC00RjExLUIyQTgtNjgwNTJCODc5NDg4IjpbXSwiMTc2Qzg2QzgtMzg5QS00NjRGLUIzRjgtNEJFNUUxNjlEOEY4IjpbXSwiMUM4Q0FCNzEtRjUxRC00NDI5LTkxN0YtQzczNDlBQzgyMTc3IjpbXSwiMUY3ODRDM0ItMTAyMi00NkU2LTg1NUMtN0U4Rjk5M0YxRDhEIjpbXSwiMkE5RTRCNTYtRDA0MC00NTYwLUE3NzAtNTY2MkZDMURGREEyIjpbXSwiMkFFREQwNEMtQjYwMi00N0I3LUEzMEMtNUQyOEMzMjIzOEE4IjpbXSwiMkIzREU5RjAtM0NGNy00RUY0LTk2RDQtMEMxQjI0NkVGRjdCIjpbXSwiMkNGMUFDOEQtRENGMi00RTlFLTk1MDEtMUIxRUUzMTZCRDhDIjpbXSwiMzU2NEJDMTctRDcyQy00NjY4LUFGM0ItQjExRjkxREI2MzNEIjpbXSwiMzU5NjNDRTEtMERENy00OTI3LUI4QTktMTgzQzA4NTM4NUJGIjpbXSwiMzZCODQ5NDgtRkE5OS00OTY4LUE3MzEtMEI0RkU0OUQ5NzU0IjpbXSwiM0I0QkJGM0UtOTIyQy00Mjc4LUJEM0YtQ0VBRDZGNTQ0ODU4IjpbXSwiNDA2NjdBRTEtODdCMi00REIzLTkzRjItMTNDQzU5MzRDRDJGIjpbXSwiNDQzMTI2Q0MtRjc0MS00Mjc3LThEQ0MtOUZCNjE3ODdFRkMyIjpbXSwiNTYwNDRBQzEtRDRBQi00ODkyLTlFRUQtMjkwODY3OUNFMDE1IjpbXSwiNTg5NTEwNEMtMDY1Ni00MTdGLThBRDItN0JCODA5NkVDMTM3IjpbXSwiNTlCM0Q0NzUtRTUyQy00REMyLUJFNjktRkIzRjI1NUE0NDE1IjpbXSwiNUM0ODhBQzktMUY1Qi00RTM4LUI1MUEtRTI4RjNGQTRDNTQwIjpbXSwiNUNEQzhFOTQtQjVGOC00REYxLUI2NDgtOEE3NUYyQ0UyQUNFIjpbXSwiNUY2QkRDQzAtRjgxMS00OTEyLTlFMEQtMDNFOUQ1NkFCQkJDIjpbXSwiNjUwNUI1MUMtQjZCNi00M0M0LUJFRjgtNDM4M0IyQjQzNjdGIjpbXSwiNjU0MjE4MTYtQTQyMC00RTMxLTg0RUQtQzg3N0VFRDQyRjlCIjpbXSwiNkJCNzk3REItMjgyOS00OTZELUI5MzYtRUZGREI5RTMzN0VFIjpbXSwiNkMwNEQyQjItQkYyQi00ODgxLTg0RTktNzNEMURCMjUwQTMxIjpbXSwiNzRBMEJGQzctREQ5Qi00NDczLTgxQUUtNjdDQUI1MDcxODMyIjpbXSwiNzZEMjdBRDUtNDQ3NC00M0NCLThBMzctMzQ3N0Y4QkUwNjg5IjpbXSwiN0EwQUIyMjMtQUE2QS00NTQ0LUIzMzEtNjk1Qzk2QkEyMTVEIjpbXSwiN0Q1N0Q0NjEtMUM4Ny00RkE1LUE5MUMtMUZDMDM3OUNFODVBIjpbXSwiODJBMkU2RUUtRTY4OS00Rjc1LUIzRjItMEI1NDU5QTJDODhDIjpbXSwiODgzMThGQkEtODc0OC00OUJCLTlCMEQtMTgxRURCNDNCNzA1IjpbXSwiODk3MEMwMjQtMUFEMS00MDQ2LTg4NjUtRDREMzg4OUQyRkRBIjpbXSwiOERDOTYyNzktM0RBMS00QzU0LUFCNDYtRDRDOUJDQUQxRUE4IjpbXSwiOEU2MzRCQUEtNDRFQy00QUJELTkyMzQtNUE0QTlBQ0I0NjFBIjpbXSwiOTFFRkRGOTMtNThFRC00RTI1LUIyQzctMjY1OThGRjdFMTgzIjpbXSwiOTI5MDg3NTAtNDlBMS00MURELUExQTEtMEVCNzMwMzVCOTdCIjpbXSwiOTJERkVFMjAtOEY2NS00MThCLUJDN0MtMzM0OTNGNDdBNjRBIjpbXSwiOTU3QzJDRDQtRDkxOS00NkVBLThBNTMtRjFDQkI1Q0I4OUJFIjpbXSwiOTk4NEFBNkQtRjFDNS00MDAxLUIzNjAtMkRCNjNBOEJGNDg3IjpbInByb2plY3RSZWFkIiwicHJvamVjdFVwZGF0ZSIsInByb2plY3REZWxldGUiLCJkZXBsb3ltZW50Q3JlYXRlIiwiZGVwbG95bWVudFJlYWQiLCJkZXBsb3ltZW50VXBkYXRlIiwiYXBwbGljYXRpb25DcmVhdGUiLCJhcHBsaWNhdGlvblJlYWQiLCJhcHBsaWNhdGlvblVwZGF0ZSIsImFwcGxpY2F0aW9uRGVsZXRlIiwicGVybWlzc2lvblVwZGF0ZSJdLCI5QkVGQzM3MC0zNTMwLTQwMzYtQUM3RS03QkM0MDdFMTE5QUIiOltdLCI5QzY2OURFNC0zOTM4LTRGNjQtQTMxMi0yQjY4RDlFQTdEMzYiOltdLCI5REIzNjg5My01MzI2LTREOUMtQTUwNC04OTc4OUY2N0VFNzQiOltdLCI5RENFQzBCMi1GNEU3LTQxQzEtOURGQy0zRjEzMTBCMTQxNUUiOltdLCI5RTYxMDM3MS0yRThBLTRFNEItQkVGOC0yMEI3Mzg4RjY3NUYiOltdLCI5RUQ0MEMxNy00NzJFLTRBNEQtOTA3NC1EOTQ4MTk1Q0I5QjUiOltdLCI5RjI5NDA1My1COEEwLTQyRjEtQjYwQy03RjJBNDE2M0FDNjAiOltdLCJBNDkxNTVDNi0xRTgzLTQ2NjYtQkZGMi0yMDlGNTA4NTdGN0YiOltdLCJBNUFFODgwOC1EN0I4LTQ5RUUtODNCNy1CNjkxQ0MyQzlEQTgiOltdLCJBQjJGQzQwOS1FRjhGLTQ5QkEtQTU1NC00RDc3RTExNzFGNUEiOltdLCJBRjM1RTIyMS04NDlCLTRDMEUtQTJCNC04OTczMzNEMjNDNTYiOltdLCJCMDQ4MTcwMy0yM0FFLTRFMTgtOUU0NS05RUQ5QjY0RDc2QkUiOltdLCJCOEQ4NUIxRC0yNzc4LTQ5QzctQjhBQy05NkUwQzlEMDM4QkUiOltdLCJCOThGMzlBMy1DRUE3LTRDMjQtQUYwOS04MTBEQ0U3RDUyMTIiOltdLCJCQ0NFNzk1OC1DQ0E1LTQ3MzktQUY5MC0wRTc3RjA5REUxNkQiOltdLCJCRDE5MjNBMi00QzcxLTQxNDctQTlCNy0wODdFMDVDRjA2N0UiOltdLCJCRDdEQkE3Ri1DQ0EyLTRENjEtOUQ3MC02RTlDQTEyMkY5N0UiOltdLCJCRTkxRDg3Ri04NTNELTQwMEQtOEE0OS0wQjdFQjYwQzkzQjgiOltdLCJDNkMxRjhFOS1CNzExLTRDRUEtQjFBNC0zNkREODBGMDgyMTciOltdLCJDODZDMUFCMi1EMTk2LTRCNjQtOUY0Mi00Q0E4NjFFRUM4MEEiOltdLCJDRTk4ODIxOC0wQjUzLTRCNDAtQjhCQy1GMDlGNENGRjQ0QjYiOltdLCJEMzYzM0YxMC0wMUI2LTQxNjQtQkYzOC1FNUFDNTQ0Q0JFRTkiOltdLCJENDNENzE3Ni1BM0QyLTREOUQtOTY1NS1BODQ3OTZBQUZGMjMiOltdLCJEODEwOEJBNy02MjEyLTQ1QzgtOEE0NS03NzVBRUQ5MDBBRTMiOltdLCJEOTQyQzgyNy1DQUJBLTRFQkUtOUJFRS0wMTg5RkRFNDg3OTgiOltdLCJEQjFCNUYwNC02RjU1LTQwNEItOTlERS1BQzkzMUNENkE0NUUiOltdLCJERTA3OERCRC05Mjc1LTRFMzgtQTkxRC02MzVDODZCN0U3N0EiOltdLCJERjQzMjY5My1FMzBFLTQwOEUtQTA1NS1FRTVDNjZCOTZDMDgiOltdLCJFMUQ0MEQ4My1FNTdFLTQ0MkYtQjRBQS02ODc3OUFCREY3NEEiOltdLCJFQTg4REVFMy1DNTQ5LTQ5NUMtQUM0MS0zNThDQjFFNkVDOTMiOltdLCJFQzkyQTUwNS1CQzEwLTQ3MjUtQkE5OS0yRDBDRDZGREE3NjMiOltdLCJFRDEyMUI5Qi02Qjk1LTQwMkEtQUNDQi0wODg4QjQ4ODg1QTMiOltdLCJFRTkyNUE0Mi0xNDg0LTQ1QzEtQUVENS01QjhCREQzRDE0NzciOltdLCJFRUFENzZBNi0zQkFDLTRFNkQtODMyRC1GNTI1ODI4N0QzMkYiOltdLCJFRUQ2Qzc4NC1BQzhDLTQyRTktQjJCOS1FQ0JFMEFBMTA5QzciOltdLCJFRUZGNjUxQS01NjA2LTQ4MDItOTk3MS05MUYyMDAzOUI2QUQiOltdLCJGMTVEQ0JEMy0xRjk1LTQzNjMtOEU1RC0yRTFFMTQyOTIwQ0QiOltdLCJGMjBFNEMwNC0zRTczLTQzNzQtQTYwMy1DNUQ5OTY0NzVENkUiOltdLCJGRDhEM0RCMS01MjAyLTQwNDEtQTZDRS0wOTAwNjM3NEU2NzAiOltdLCJGRDk1M0ExMC03QkU0LTQyMzctQkFBRi1DRkQ3MEVFRkUyNEIiOltdfX0sInVzZXIiOnsiaWQiOiI1QjIxMzAyRS0zODI4LTQyMjUtOUQzRi0zNTU2MjQxNDhCOEUiLCJuYW1lIjoiRm9vIEJhciJ9fQ.Ny016D-ivZV4k1fsn9NSijFADSS2FLDo31-v71iNv6RWDL1qKJZ1txhaD4qxS7H80IjC-MAEXYx72v2w5IWXcw"
let refresh = "Ucbii+jJp5TmqVxQWnai0J1pjoeHlfjYnBhkNDd1pV0="
let token = Token(access: access, refresh: refresh)

let testProjectNode: Node = [
    "id": "9984AA6D-F1C5-4001-B360-2DB63A8BF487",
    "name": "Test project",
    "color": "657591",
    "organization": [
        "id": "7140266E-FBBE-4932-8630-44A85A05C31D"
    ]
]

let project = try! Project(node: testProjectNode)
let testNamePrefix = "aAa - "
class ApplicationApiTests: XCTestCase {
    func testCreateApplication() throws {
        let email = newEmail()
        let token = try adminApi.createAndLogin(
            email: email,
            pass: pass,
            firstName: "Testerton",
            lastName: "Reelston",
            organizationName: "Real Business, Inc.",
            image: nil
        )

//        let projects = try adminApi.projects.all(with: token)
//        print("Projects: \(projects)")
//        print("")
        guard let org = try adminApi.organizations.all(with: token).first else {
            XCTFail("Failed to get organization for test user")
            return
        }

//        let orgPermissions = try adminApi.organizations.permissions.get(for: org, with: token)
//        print("Org permissions: \(orgPermissions.map { $0.key })")

        let project = try adminApi.projects.create(
            name: "Test-Project",
            color: nil,
            in: org,
            with: token
        )
//        let projPermissions = try adminApi.projects.permissions.get(for: project, with: token)
//        print("Pro permissions: \(projPermissions.map { $0.key })")
//
//        let allProjPermissions = try adminApi.projects.permissions.all(with: token)
//        let user = try adminApi.user.get(with: token)
//        let result = try adminApi.projects.permissions.set(allProjPermissions, for: user, in: project, with: token)
//        XCTAssertEqual(allProjPermissions, result)
//
//        let projects2 = try adminApi.projects.all(with: token)
//        print("Projects: \(projects2)")
//        print("")
//
//        let refreshed = try adminApi.access.refresh(token)
        let name = testNamePrefix + Date().timeIntervalSince1970.description
        let application = try! applicationApi.create(
            for: project,
            repo: "test-app-\(Int(Date().timeIntervalSince1970))",
            git: "git@github.com:vapor/api-template.git",
            name: name,
            with: token
        )
        print(application)
        print("")
    }
}
