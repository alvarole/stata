*FDSDO
/*===========================================================================
Programa:		fdsdo.ado
Autor:			Alvaro Lopez-Espinoza
Resultado:		Crea plantillas para do-files de FUNIDES
Institucion: 		FUNIDES
---------------------------------------------------------------------------
Fecha de creacion: 	Marzo 2019
Producto:		fdsdo.ado
===========================================================================*/

cap program drop fdsdo
program define fdsdo

syntax , [ File(string) 						/// Nombre del do-file
           Path(string) 						/// directory path where do-file will be placed
           AUThor(string) 						/// Author name
           PROject(string) 						/// Proyecto
           GOAl(string) 						/// Objective of the do-file
           AREA(string) 						/// list of files produced with the do-file
           SECtions(string)						/// Number of sections in do-file
           STEPs(string)						/// number of steps with sections
           log  								/// produced log file with the same name as the do-file
           replace								/// replace
           ]
  

version 10.0

/*================================
Section 1: create locals
================================*/


* 1.1: Default locals
* Producto
if ("`area'" == "") disp in y  ///
	"Area:" _n ///
	_request(_area)
	
* Nombre del do-file
if ("`file'" == "") {
	disp in y  "Nombre del do-file:" _request(_file)
	if ("`file'" == "") local file "dofile1"
}

* Objetivo
if ("`goal'" == "") disp in y  "Objetivo del do-file:" _request(_goal)

* Proyecto
if ("`project'" == "") {
	disp in y  "Nombre del proyecto de investigacion:" _request(_project)
}

* Autor
if ("`author'" == "") {
	disp in y "Autor/a (es):" _n ///
	"Formato: Nombre1 Apellido1 (email1) ; Nombre2 Apellido2 (email2) " _request(_author)
	if ("`author'" == "") local author = "FUNIDES"
}


* Secciones
if ("`sections'" == "") {
	disp in y  "Numero de secciones estimadas:" _request(_sections)
	if ("`sections'" == "") local sections = 3
}

* Subsecciones
if ("`steps'" == "") {
	disp in y  "Numero de subsecciones estimadas:" _request(_steps)
	if ("`steps'" == "") local steps = 1
}

* Path
if ("`path'" == "") {
	disp in y  "Directorio para guardar do-file:" _n   ///
		"(el directorio actual por default):" _request(_path)
	if (`"`path'"' == `""') local path = "`c(pwd)'"
}


* log
if ("`log'" == "") {
	disp in y  "¿Te gustaria crear un log-file? s/n" ///
		_request(_log)
}

* 1.2: Temporal files and names

tempfile dofile
tempname do
file open `do' using `dofile', write `replace'


*================================
* Section 2: Create do-file
*===============================

* 2.1 Header

if (inlist("`log'", "log", "s")) {						// if log file is desired
	file write `do' `"capture log close"' _n  //
	file write `do' `"log using "`path'/`file'.txt", replace text"' _n  
}

if (inlist("`log'", "log", "S")) {						// if log file is desired
	file write `do' `"capture log close"' _n  //
	file write `do' `"log using "`path'/`file'.txt", replace text"' _n  
}

file write `do' `"/*"' _n 
file write `do' `"                         /yy:     "'   _n                                                                                                                                                                   
file write `do' `"                       -shho°     "'   _n                                                                                                                                                                   
file write `do' `"              .//:°  °+hhy:       "'   _n                                                                                                                                                                  
file write `do' `"         °°   oooo: :yhy+°        "'   _n                                                                                                                                                                   
file write `do' `":/-°    +hyo:°.:/:.ohhs-.//                °:/oossssssss    °sss/        osss     °sssss-      :sss.     osss°     -sssssssssso+/.°        °-/oosssssss+     °:+ossssssssssss°"' _n
file write `do' `"-+oo+:.°./syhyo/./yhy/°:oo/              °+yhhhyssssssss    .hhho        yhhy     °hhhhhy:     /hhh.     yhhh.     :hhhyssssssyhhhs-     °+yhhyysssssss+    °shhhysssssssssss°"' _n
file write `do' `"  °-/+o+/-°.:oyhhhho..+o+.               +hhhs-°            .hhho        yhhy     °hhhyyhh/    /hhh.     yhhh.     :hhh/      °:yhhy-    ohhhs-°            +hhho.            "' _n
file write `do' `"     °.:+oo/-..-+o:°/oo:°                yhhh.              .hhho        yhhy     °hhho-yhh/   /hhh.     yhhh.     :hhh/        +hhho   -hhhh.°°°°°°°°°°    +hhh+°            "' _n
file write `do' `"         .:+oo+:   :oo/°                °hhhhsssssssssss    .hhho        yhhy     °hhho .yhh+° /hhh.     yhhh.     :hhh/        :hhhs   /hhhhssssssssss+    .shhhysssssssso+- "' _n
file write `do' `"            -oo/ °.°-+o+-               °hhhhsssssssssss    .hhho        yhhy     °hhho  .shho°/hhh.     yhhh.     :hhh/        :hhhs   /hhhhoooooooooo/     °:+ossssssssyhhh/"' _n
file write `do' `"            +o+°.yyo.°:oo/.             °hhhy               .hhho        yhhy     °hhho   °shhs+hhh.     yhhh.     :hhh/        +hhh+   -hhhh°                    °°°°°°°-hhhy"' _n
file write `do' `"           /oo°.yhhhyo.°/oo/°           °hhhy               °yhhy-      /hhhs     °hhho    °ohhhhhh.     yhhh.     :hhh/     °./yhhy.    ohhhs-°             °°°°°°°°°°°°:hhhy"' _n
file write `do' `"          -oo-°shy/oyhyo-./oo:°         °hhhy                :yhhyso++oshhhs.     °hhho     °+hhhhh.     yhhh.     :hhhyssyyyyyhhhs-      /yhhyyyssssss+     syyyyyyyyyyyhhhy:"' _n
file write `do' `"          -/-°shy.  ./yhyo°.+oo-        °oooo                 °:+osssssoo/-       °ooo/       /oooo.     oooo°     -ooooooooooo+/-°        °-/+oooooooo/     ooooooooooooo+:° "' _n
file write `do' `"             ohs°     °-+:   -++°                                                                                                                                             "' _n                     
file write `do' `"            +h+°                                                                                                                                                              "' _n                    
file write `do' `"           -y/                                                                                                                                                                "' _n
file write `do' `""' _n 
file write `do' _dup(100) `"="' _n
file write `do' `"Area: "'  _col(25) `"`area' "' _n  
file write `do' `"Proyecto:"'  _col(25) `"`project'"' _n 			
file write `do' _dup(100) `"-"' _n 
file write `do' `"Nombre del do-file: "'  _col(25) `"`file' "' _n  	
file write `do' `"Autor/a (es): "'  _col(25) `"`author' "' _n  	
file write `do' `"Objetivo del do-file: "'  _col(25) `"`goal' "' _n  	
file write `do' `"Fecha de creacion:"' _col(25) ///
	`"`c(current_date)'"' _n
file write `do' _dup(98) `"="' `"*/"' _n
file write `do' `""' _n 
file write `do' `"/*"' _dup(98) `"="'  _n
file write `do' _col(10) `"TABLA DE CONTENIDO"' _n
file write `do' `""' _n 
	foreach section of numlist 1/`sections' {
		file write `do' _col(5) `"`section'. "' _n  		
		if (`steps' > 1) {
			foreach step of numlist 1/`steps' {
				file write `do' _col(8) `"`section'.`step'."'  _n  
			}
		}		// end of step loop
	}			//  end of Sections loop
file write `do' _dup(98) `"="' `"*/"' _n

*2.2 Page set-up
file write `do' `""' _n  
file write `do' `"/*"' _dup(98) "=" _n  
file write `do' _col(10) `"COMANDOS INICIALES"' _n  		
file write `do' _dup(98) "=" `"*/"' _n 
file write `do' `""' _n 
file write `do' `"version `c(stata_version)'"' _n  	
file write `do' `"drop _all"' _n
file write `do' `"clear all"' _n
file write `do' `"set more off, perm"' _n
file write `do' `"set type double, perm"' _n
file write `do' `""' _n 

*2.3 Secciones
	foreach section of numlist 1/`sections' {
		file write `do' `"/*"' _dup(98) "=" _n 	
		file write `do' _col(10) `"`section': "' _n  		
		file write `do' _dup(98) "=" `"*/"' _n 	
		file write `do' `""' _n    
		file write `do' `""' _n 
		file write `do' `""' _n 
		
		if (`steps' > 1) {
			foreach step of numlist 1/`steps' {
				file write `do' `"*"' _dup(12) "-" `"`section'.`step':"'  _n  
				file write `do' `""' _n
				file write `do' `""' _n 
				file write `do' `""' _n 
			}
		}		// end of step loop
	}			//  end of Sections loop
* Few spaces before closing
file write `do' `""' _n  
file write `do' `""' _n  
file write `do' `""' _n  

* In case log file is selected
if (inlist("`log'", "log", "S")) file write `do' `"log close"' _n  

* 2.4 Closing lines
file write `do' `"exit"' _n  
file write `do' `"/* FINAL DE DO-FILE */"' _n
file write `do' `""' _n  
file write `do' ">" _dup(39) "<>" "<" _n  

file write `do' `""' _n  
file write `do' `"ANOTACIONES:"' _n  
file write `do' `"1."' _n  
file write `do' `"2."' _n  
file write `do' `"3."' _n  
file write `do' `""' _n  
file write `do' `""' _n  
file write `do' `"Plantilla basada en paquete "dotemplate" de Andres Castaneda (http://fmwww.bc.edu/repec/bocode/d/dotemplate.ado)"' _n  


*================================
* Section 3: Closing file
*===============================

file close `do'
cap confirm new file "`path'/`file'.do"
if _rc {
	cap window stopbox rusure `"The file "`path'/`file'.do" "' ///
		"already exists." "Do you want to replace it?"
	if (_rc == 0) copy `dofile' "`path'/`file'.do", replace
	else exit
	di as txt "Click" as smcl `"{browse `""`path'/`file'.do""': here }"' ///
		`"to open template "`file'.do" with your default software"'
}

else {
	copy `dofile' "`path'/`file'.do"
	di as txt "Click" as smcl `"{browse `""`path'/`file'.do""': here }"' ///
		`"to open template "`file'.do" with your default software"'
}

end

exit 
