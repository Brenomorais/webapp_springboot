-- Criando os objetos do banco de dados

/*CRIANDO A TABELA DE GRUPOS : registro com grupos de permiss�es de acesso ao sistema*/
CREATE TABLE breno.tb_grupo
( 
  id_grupo     INT           PRIMARY KEY NOT NULL,
  ds_nome      VARCHAR(50)   NOT NULL,
  ds_descricao VARCHAR(200)  NOT NULL
);

/*CRIANDO A TABELA DE PERMISS�ES: armazena permiss�es de acesso do sistema */
CREATE TABLE breno.tb_permissao
(
   id_permissao INT PRIMARY KEY NOT NULL,
   ds_permissao VARCHAR(50)    NOT NULL,
   ds_descricao VARCHAR(200)   NOT NULL   
);

/*CRIANDO A TABELA DE USU�RIOS: registro dos usuarios*/
CREATE TABLE breno.tb_usuario
(
  id_usuario INT PRIMARY KEY NOT NULL,
  ds_nome    VARCHAR(60)      NOT NULL,
  ds_login   VARCHAR(60)      NOT NULL,
  ds_senha   VARCHAR(400)     NOT NULL,
  fl_ativo   NUMBER(1)        NOT NULL
);

/*CRIANDO A TABELA DE USU�RIO X GRUPO: vincula usuarios ao grupo de acesso ao sistema */
CREATE TABLE breno.tb_usuario_x_grupo
(
  id_usuario INT NOT NULL,  
  id_grupo   INT NOT NULL,
  CONSTRAINT PK_USU_GRUP   PRIMARY KEY(id_usuario,id_grupo),
  FOREIGN KEY(id_usuario) REFERENCES tb_usuario(id_usuario), 
  FOREIGN KEY(id_grupo)  REFERENCES tb_grupo(id_grupo)
);

/*CRIANDO A TABELA DE PERMISS�O X GRUPO: table com as especificas permiss�es de cada grupo*/
CREATE TABLE breno.tb_permissao_x_grupo
(
  id_permissao INT NOT NULL,  
  id_grupo     INT NOT NULL,
  CONSTRAINT PK_PER_GRUP   PRIMARY KEY(id_permissao,id_grupo),
  CONSTRAINT FK_PERM_1 FOREIGN KEY(id_permissao) REFERENCES tb_permissao(id_permissao), 
  CONSTRAINT FK_GRUP_1 FOREIGN KEY(id_grupo)  REFERENCES tb_grupo(id_grupo)
);

/*SEQUENCE DA TABELA tb_grupo*/
CREATE SEQUENCE seq_id_grupo
MINVALUE 1                    /* VALOR MINIMO */
MAXVALUE 9999999999           /* VALOR M�XIMO */
START WITH 1                  /* VALOR INICIAL */
INCREMENT BY 1;               /* INCREMENTA DE 1 EM 1 */

/*SEQUENCE DA TABELA tb_permissao*/
CREATE SEQUENCE seq_id_permissao
MINVALUE 1                    /* VALOR MINIMO */
MAXVALUE 9999999999           /* VALOR M�XIMO */
START WITH 1                  /* VALOR INICIAL */
INCREMENT BY 1;               /* INCREMENTA DE 1 EM 1 */

/*SEQUENCE DA TABELA tb_usuario*/
CREATE SEQUENCE seq_id_usuario
MINVALUE 1                    /* VALOR MINIMO */
MAXVALUE 9999999999           /* VALOR M�XIMO */
START WITH 1                  /* VALOR INICIAL */
INCREMENT BY 1;               /* INCREMENTA DE 1 EM 1 */

/*Inserindo grupo da nossa aplica��o tb_usuario*/
INSERT INTO breno.tb_grupo(id_grupo, ds_nome, ds_descricao)
    VALUES(seq_id_grupo.NEXTVAL,'ADMINISTRADORES','Adminitrador');
 
INSERT INTO breno.tb_grupo(id_grupo,ds_nome,ds_descricao)
    VALUES(seq_id_grupo.NEXTVAL,'USUARIOS','Usu�rios Comum');
 
INSERT INTO breno.tb_grupo(id_grupo, ds_nome, ds_descricao)
    VALUES(seq_id_grupo.NEXTVAL,'BACKOFFICE','Backoffice - Cadastros');
    
/*Inserindo usuario de teste: senha est� criptografada, a senha � 123456 */
INSERT INTO breno.tb_usuario (id_usuario,ds_nome,ds_login,ds_senha,fl_ativo)
    VALUES(seq_id_usuario.NEXTVAL,'Breno Lopes','breno','$2a$10$YYe9VtFGZoWvrNSZNV/AeuVSTOMQLxcGia4IQEl/yVaxrfAnPDcuO',1);
    
/*Inserindo permiss�es do sistema */
INSERT INTO breno.tb_permissao(id_permissao,ds_permissao,ds_descricao)
    VALUES(seq_id_permissao.NEXTVAL,'ROLE_CADASTROUSUARIO','CADASTRO DE NOVOS USU�RIOS');
 
INSERT INTO breno.tb_permissao(id_permissao,ds_permissao,ds_descricao)
    VALUES(seq_id_permissao.NEXTVAL,'ROLE_CONSULTAUSUARIO','CONSULTA DE USU�RIOS');                                   
    
INSERT INTO breno.tb_permissao(id_permissao,ds_permissao,ds_descricao)
    VALUES(seq_id_permissao.NEXTVAL,'ROLE_ADMIN','ADMINISTRA��O COMPLETA');
    
/* Associando usuario criado com o grupo administradores*/
INSERT INTO breno.tb_usuario_x_grupo(id_usuario,id_grupo)VALUES(1,1);

/* cadastrando permiss�es para os grupos */

/*ROLE_CADASTROUSUARIO x BACKOFFICE*/
INSERT INTO breno.tb_permissao_x_grupo(id_permissao,id_grupo)VALUES(1,3); 
 
/*ROLE_CONSULTAUSUARIO x USUARIOS*/
INSERT INTO breno.tb_permissao_x_grupo(id_permissao,id_grupo)VALUES(2,2);
 
/*ROLE_ADMIN x ADMINISTRADORES*/
INSERT INTO breno.tb_permissao_x_grupo(id_permissao,id_grupo)VALUES(3,1);

/*Consultando: configura��o realizada*/

SELECT
  TB_PERMISSAO_X_GRUPO.ID_PERMISSAO,
  TB_PERMISSAO.DS_PERMISSAO,
  TB_PERMISSAO.DS_DESCRICAO,
  TB_PERMISSAO_X_GRUPO.ID_GRUPO,
  TB_GRUPO.DS_NOME
FROM
  TB_PERMISSAO_X_GRUPO TB_PERMISSAO_X_GRUPO
INNER JOIN  TB_GRUPO TB_GRUPO ON  TB_GRUPO.ID_GRUPO = TB_PERMISSAO_X_GRUPO.ID_GRUPO 
INNER JOIN  TB_PERMISSAO TB_PERMISSAO ON TB_PERMISSAO.ID_PERMISSAO  = TB_PERMISSAO_X_GRUPO.ID_PERMISSAO;


