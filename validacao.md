---
title: "Validacao DETER-R - artigo"
author: "Mariane S. Reis"
date: "versao de 22/01/2023"
output:
   html_document:
      toc: true
      toc_float: true
      code_folding: hide
---

```{r include = FALSE}

options(scipen=999)

library(data.table)
library(dplyr)
library(formattable)
library(tidyr)
library(readxl)
library(knitr)
library(magrittr)
library(questionr)
library(sf)
library(rgdal)
library(anytime)


path<-"D:/_DETER_R/Acuracia/datasource.xml"
#root_folder    <- dirname(rstudioapi::getSourceEditorContext()$path)

layers <- ogrListLayers(path)

#alertas <- st_read (path,"deter-sar:deter_sar_amz_dot4")              
alertas <- st_read (path,"deter-sar:deter_sar_amz")              

#validados <- st_read (path,"deter-sar:deter_sar_1ha_validados_dot4")  
validados <- st_read (path,"deter-sar:deter_sar_1ha_validados")  


# #Atribui a tab_v a tabela com os polígonos validados. Essa tabela contém a classe atribuída pelos avaliadores.
tab_v<-validados%>% st_drop_geometry()
 
 #Atribui a tab_a a tabela com os polígonos detectados. Essa tabela contém os valores de "intensity" (diferença de intensidade)
tab_a<-alertas%>% st_drop_geometry()

# #Une tab_v e tab_a pelo identificador dos polígonos. Essa tabela contém os valores de "intensity" e as classes atribuídas pelos avaliadores.
tab_m<-merge(tab_v, tab_a, by= 'uuid')
tab_m<-tab_m[which(tab_m$nome_avaliador!="andre.carvalho"),]

tipo_data<-"created_at" #filtra por "created_at" ou "view_date"

#datai<-min(anydate(tab_m$created_at.x)) #"2021-04-21", "2021-02-23"
# datai<-min(anydate(tab_m$created_at.x))
# dataf<-max(anydate(tab_m$created_at.x))
 datai<-anydate("2022-08-01")
 dataf<-anydate("2022-09-30")



areai<-min(tab_m$area_ha.x)
areaf<-max(tab_m$area_ha.x)

limiar<-"o" #"o" se quiser usar o limiar original. Valor caso queira trocar o limiar.

if (is.numeric(limiar)){
text.limiar<-paste0("= ", limiar)} else {text.limiar<-"original"}

```
Esse relatório apresenta os valores de acurácia operacional para o sistema DETER-R, para alertas detectados entre `r datai` e `r dataf`, e com área entre `r areai` e `r areaf` ha.  Para definição se o alerta é de Alto impacto (CLEAR_CUT) ou de Baixo impacto (DEGRADATION), foi considerado o limiar `r text.limiar`.

Alertas de Alto impacto (CLEAR_CUT)  e Baixo impacto (DEGRADATION) são validados de forma automática ou por interpretação visual. Os alertas detectados diariamente são sobrepostos aos polígonos de desmatamento do DETER-B, e validados se forma automática se houver sobreposição de 50% ou mais. Dos polígonos não validados automaticamente, os 100 maiores e outros 300 selecionados de forma aleatória são validados por interpretação visual de imagens ópticas em dadas próximas, nas classes:

* DESMATAMENTO_CR;
* DEGRADACAO;
* QUEIMADA;
* RESIDUO;
* NUVEM;
* SEM_CONDICOES_AVALIACAO;
* NF;
* FALSO_POSITIVO;
* AGUA.

São 4 categorias de validação para o cálculo de acurácia dos dados:

* Acerto: alertas válidos corretamente detectados como categorias de alto ou baixo impacto;

* Erro leve: alertas válidos detectados em categorias errôneas de alto ou baixo impacto;

* Erro grave: alertas inválidos;

* Não avaliável: alertas que não podem ser classificados como válidos ou inválidos.

<br>  

Tabela 1. Equivalência das classes do DETER-R (colunas) e informações de referência (linhas).

```{r, echo=T}
tabela1<-as.data.frame(cbind(c("Acerto",
"Acerto",
"Erro leve",
"Erro leve",
"Erro leve",
"Erro grave",
"Erro grave",
"Erro grave",
"Não avaliável",
"Não avaliável"),
c("Erro leve",
"Erro leve",
"Acerto",
"Acerto",
"Erro leve",
"Erro grave",
"Erro grave",
"Erro grave",
"Não avaliável",
"Não avaliável"
)))

classes.ref<-c("Automático", "DESMATAMENTO_CR", "DEGRADACAO", "QUEIMADA","RESIDUO", "AGUA","NF", "FALSO_POSITIVO", "NUVEM","SEM_CONDICOES_AVALIACAO")
classes.deterR<-c("CLEAR_CUT", "DEGRADATION")

rownames(tabela1)<-classes.ref

colnames(tabela1)<-c("Alto impacto","Baixo impacto")

tab.f1<- formatter("span", style = x~style(display = "block",
                                                      padding = "0 4px", 
                                                 `border-radius` = "4px", 
                                                 `background-color` = c("#d8f3dc",
"#d8f3dc",
"#ffe2ab",
"#ffe2ab",
"#ffe2ab",
"#fec5bb",
"#fec5bb",
"#fec5bb",
"#dedede",
"#dedede")))
  
tab.f2<- formatter("span", style = x~style(display = "block",
                                                      padding = "0 4px", 
                                                 `border-radius` = "4px", 
                                                 `background-color` = c("#ffe2ab",
"#ffe2ab",
"#d8f3dc",
"#d8f3dc",
"#ffe2ab",
"#fec5bb",
"#fec5bb",
"#fec5bb",
"#dedede",
"#dedede")))                                               

tabela1<-formattable(as.data.frame(tabela1), align =c("c","c"), list(
  `Alto impacto` = tab.f1,
  `Baixo impacto`=tab.f2
))


tabela1

```
 
 <br>  


**Datas relevantes:**

* 17/06/2021: mudança do limiar de fatiamento usado para classificar os alertas em DEGRADATION e CLEAR_CUT (de 10 para 7 db);
* 18/06/21: inclusão da classe AGUA na validação;
* 21/07/2021: atualização da máscara de desmatamento (atualizada para dados PRODES 2020);
* 21/07/2021 - 26/07/2021: período com falha de detecção;
* 06/08/2021: atualização da máscara de desmatamento (atualizada para dados PRODES 2020 com adição de resíduos de 2020);
* 20/08/2021: atualização da máscara de desmatamento (incluída máscara de indícios agregados de 2020);
* 05/04/2022: inicio dos testes dot4;
* 29/04/2022: atualização da máscara de desmatamento (PRODES 2021 e indícios PRODES 2021 - áreas prioritárias).
* 04/07/2022: fim dos testes dot4;
* 01/08/2022: atualização dos parâmetros de área mínima (1 para 0.4 ha) e filtros de pós-processamento - início da coleção 2.

<br>  

# Número de polígonos


Tabela 2. Tabulação cruzada entre alertas do DETER-R (colunas) e informações de referência (linhas), considerando o número de polígonos.

```{r, echo=TRUE,out.width = '\\maxwidth',fig.height = 4}

#Filtra por data

if(tipo_data=="created_at"){
new_date<-tab_m$created_at.x} else{
new_date<-tab_m$view_date.x}

tab_m<-cbind(tab_m,new_date)
tab_m<-tab_m[which(anydate(tab_m$new_date)>=anydate(datai)&anydate(tab_m$new_date)<=anydate(dataf)),]


#Troca os limiares de classificação (se necessário)
if(is.numeric(limiar)){

  tab_m$class[which(tab_m$intensity>=limiar)]<- "CLEAR_CUT" 
  tab_m$class[which(tab_m$intensity<limiar)]<- "DEGRADATION"
}


#Constrói tabulação com número de polígonos
tabela2<-matrix(nrow=10, ncol=2)
tabela2[,]<-0
rownames(tabela2)<-classes.ref

colnames(tabela2)<-c("Alto impacto","Baixo impacto")

pol.aut<-table(tab_m$class[which(tab_m$nome_avaliador=="automatico")])
pol.man<-table(tab_m$classe_avaliador[which(tab_m$nome_avaliador!="automatico")],tab_m$class[which(tab_m$nome_avaliador!="automatico")])



for (d in 1:2){

  tabela2[1,d]<-pol.aut[which(rownames(pol.aut)==classes.deterR[d])]

  for (r in 2:length(classes.ref)){
    
    id.l<-which(rownames(pol.man)==classes.ref[r])
    id.c<-which(colnames(pol.man)==classes.deterR[d])
    
    if(length(id.c)>0&length(id.l)>0){tabela2[r,d]<-pol.man[id.l,id.c]}

  
  }   


}

ftabela2<-formattable(as.data.frame(tabela2), align =c("c","c"), list(
  `Alto impacto` = tab.f1,
  `Baixo impacto`=tab.f2
))

ftabela2

``` 
```{r, echo=T,out.width = '\\maxwidth',fig.height = 4}

#Cálculo de taxas e porcentagens

pol.t<-sum(tabela2[,])

id.acerto<-which(as.vector(tabela1=="Acerto"))

t.acerto<-sum(as.vector(tabela2)[id.acerto])
p.acerto<-t.acerto/pol.t*100


id.leve<-which(as.vector(tabela1=="Erro leve"))

t.leve<-sum(as.vector(tabela2)[id.leve])
p.leve<-t.leve/pol.t*100



id.grave<-which(as.vector(tabela1=="Erro grave"))

t.grave<-sum(as.vector(tabela2)[id.grave])
p.grave<-t.grave/pol.t*100



id.na<-which(as.vector(tabela1=="Não avaliável"))

t.na<-sum(as.vector(tabela2)[id.na])
p.na<-t.na/pol.t*100

``` 

Acerto = `r t.acerto` polígonos (`r round(p.acerto,1)`%) 

Erro leve = `r t.leve` polígonos (`r round(p.leve,1)`%)

Erro grave = `r t.grave` polígonos (`r round(p.grave,1)`%) 

Não avaliável = `r t.na` polígonos (`r round(p.na,1)`%) 


<br>

<!-- Figura 1. Número de polígonos detectados por dia/classe. -->

<!-- ```{r, echo=T,out.width = '\\maxwidth',fig.height = 4} -->

<!-- datas<-anydate(c(datai:dataf)) -->
<!-- y.l<-c() -->

<!-- for (l in 1:length(datas)){ -->
<!--   data<-datas[l] -->
<!--   temp<-tab_m[which(anydate(tab_m$new_date)==data),] -->
<!--   temp.aut<-temp[which(temp$nome_avaliador=="automatico"),] -->
<!--   temp.man<-temp[which(temp$nome_avaliador!="automatico"),] -->
<!--   tab.man<-as.numeric(table(temp.man$classe_avaliador)) -->
<!--   y.l<-c(y.l,tab.man) -->
<!-- } -->

<!-- ymax<-max(y.l) -->

<!-- plot(c(1:length(datas)), c(1:length(datas)), type="n", xaxt="n",ylim=c(0,ymax),xlab="data", ylab="#pols") -->

<!-- ``` -->

# Área dos polígonos


Tabela 3. Tabulação cruzada entre alertas do DETER-R (colunas) e informações de referência (linhas), considerando a área dos polígonos.

```{r, echo=TRUE,out.width = '\\maxwidth',fig.height = 4}

#Constrói tabulação com áreas dos polígonos

tabela3<-matrix(nrow=10, ncol=2)

rownames(tabela3)<-classes.ref

colnames(tabela3)<-c("Alto impacto","Baixo impacto")


for (d in 1:2){

  id.tab_m<-which(tab_m$nome_avaliador=="automatico"&tab_m$class==classes.deterR[d])
  
  tabela3[1,d]<-sum(tab_m$area_ha.x[id.tab_m])
  
    for (r in 2:length(classes.ref)){
    
    id.tab_m<-which(tab_m$nome_avaliador!="automatico"&tab_m$class==classes.deterR[d]&tab_m$classe_avaliador==classes.ref[r])

    tabela3[r,d]<-sum(tab_m$area_ha.x[id.tab_m])
  }   


}

ftabela3<-formattable(as.data.frame(tabela3), align =c("c","c"), list(
  `Alto impacto` = tab.f1,
  `Baixo impacto`=tab.f2
))

ftabela3

``` 
```{r, echo=T,out.width = '\\maxwidth',fig.height = 4}

#Cálculo de taxas e porcentagens

area.t<-sum(tabela3[,])

#id.acerto<-which(as.vector(tabela1=="Acerto"))

t.acerto<-sum(as.vector(tabela3)[id.acerto])
p.acerto<-t.acerto/area.t*100


#id.leve<-which(as.vector(tabela1=="Erro leve"))

t.leve<-sum(as.vector(tabela3)[id.leve])
p.leve<-t.leve/area.t*100



#id.grave<-which(as.vector(tabela1=="Erro grave"))

t.grave<-sum(as.vector(tabela3)[id.grave])
p.grave<-t.grave/area.t*100



#id.na<-which(as.vector(tabela1=="Não avaliável"))

t.na<-sum(as.vector(tabela3)[id.na])
p.na<-t.na/area.t*100

``` 

Acerto = `r round(t.acerto,2)` ha (`r round(p.acerto,1)`%) 

Erro leve = `r round(t.leve,2)` ha (`r round(p.leve,1)`%)

Erro grave = `r round(t.grave,2)` ha (`r round(p.grave,1)`%) 

Não avaliável = `r round(t.na,2)` ha (`r round(p.na,1)`%) 

