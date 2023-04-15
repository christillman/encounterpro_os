# In Excel, 
#	1. Replace all , with !
#	2. Replace all " with ^
#	3. Save as CSV

# In Linux, 
# 	1. Find lines outside of the grouping format; not beginning 
# with either a digit or , ... you might want to figure out 
# where it goes and edit manually
# awk '$1 !~ /[0-9,]/ { print }' "Uganda Dec2021DrugRegister-nocomma-noquote.csv"

# 	1. eliminate Windows CRs, blank lines
cat "Uganda Dec2021DrugRegister-nocomma-noquote.csv" |\
sed 's/\r//g' |\
awk '$0 !~ ",,,,,,,,,,,,"' > x1.csv
# Next compress lines with quotes with previous lines
# and try to fix induced spaces from line breaks in the original
awk -f compress.awk x1.csv | \
sed 's/PHARMACEUTICA LS /PHARMACEUTICALS /g' | \
sed 's/ AZIDE/AZIDE/g' | \
sed 's/CLAV ULANATE/CLAVULANATE/g' | \
sed 's/SULB ACTAM/SULBACTAM/g' | \
sed 's/ÂµG/MCG/g' | \
sed 's/I *U *M/IUM/g' | \
sed 's/AN HYDROUS/ANHYDROUS/g' | \
sed 's/CH *LO */CHLO/g' | \
sed 's/ EDRINE/EDRINE/g' | \
sed 's/ INE/INE/g' | \
sed 's/RAMIN E/RAMINE/g' | \
sed 's/RIMIN E/RIMINE/g' | \
sed 's/PH *A *N/PHAN/g' | \
sed 's/BENZ /BENZ/g' | \
sed 's/NIUM/NIUM/g' | \
sed 's/ VUDINE/VUDINE/g' | \
sed 's/NICO L/NICOL/g' | \
sed 's/A MM/AMM/g' | \
sed 's/EIN E/EINE/g' | \
sed 's/ZIN E/ZINE/g' | \
sed 's/LIN E/LINE/g' | \
sed 's/PAR *AC *ET *AMO *L/PARACETAMOL/g' | \
sed 's/CA *F *F/CAFF/g' | \
sed 's/MULTINGREDIENT/MULTI-INGREDIENT/g' | \
sed 's/B *RO *M/BROM/g' | \
sed 's/ME TH/METH/g' | \
sed 's/P *H *EN/PHEN/g' | \
sed 's/SERRAT IO/SERRATIO/g' | \
sed 's/CHL /CHL/g' | \
sed 's/PIOG LIT/PIOGLIT/g' | \
sed 's/HYD RO/HYDRO/g' | \
sed 's/ZID E/ZIDE/g' | \
sed 's/XID E/XIDE/g' | \
sed 's/MID E/MIDE/g' | \
sed 's/SON E/SONE/g' | \
sed 's/SALICYLIC CID/SALICYLIC ACID/g' | \
sed 's/M *ETF *OR *MIN/METFORMIN/g' | \
sed 's/DON A/DONA/g' | \
sed 's/AMO DIA/AMODIA/g' | \
sed 's/C AFF/CAFF/g' | \
sed 's/MAGNESS/MAGNES/g' | \
sed 's/MINE E/MIN E/g' | \
sed 's/MINE A/MIN A/g' | \
sed 's/THA NE/THANE/g' | \
sed 's/A CILLIN/ACILLIN/g' | \
sed 's/ISI NIN/ISININ/g' | \
sed 's/S OLE/SOLE/g' | \
sed 's/GENT A/GENTA/g' | \
sed 's/METH YL/METHYL/g' | \
sed 's/MEN *TH *OL/MENTHOL/g' | \
sed 's/MI DE/MIDE/g' | \
sed 's/AM *I *N/AMIN/g' | \
sed 's/TR OPIN/TROPIN/g' | \
sed 's/TATI N/TATIN/g' | \
sed 's/ESI NIN/ESININ/g' | \
sed 's/TRIC IT/TRICIT/g' | \
sed 's/ANTI- D/ANTI-D/g' | \
sed 's/MET HIC/METHIC/g' | \
sed 's/MAGN ES/MAGNES/g' | \
sed 's/DEXT ROM/DEXTROM/g' | \
sed 's/MH EX/MHEX/g' | \
sed 's/CLOX A/CLOXA/g' | \
sed 's/Z *O *LE/ZOLE/g' | \
sed 's/MI NERA/MINERA/g' | \
sed 's/G UAI/GUAI/g' | \
sed 's/FRE EZE/FREEZE/g' | \
sed 's/NEV IRA/NEVIRA/g' | \
sed 's/P ENI/PENI/g' | \
sed 's/BIN ANT/BINANT/g' | \
sed 's/THYM OL/THYMOL/g' | \
sed 's/YT ES/YTES/g' | \
sed 's/FAN TRI/FANTRI/g' | \
sed 's/DIC LO/DICLO/g' | \
sed 's/POTA SS/POTASS/g' | \
sed 's/SIM ET/SIMET/g' | \
sed 's/IT HR/ITHR/g' | \
sed 's/SO PRA/SOPRA/g' | \
sed 's/EP HED/EPHED/g' | \
sed 's/D IPH/DIPH/g' | \
sed 's/D EXTRO/DEXTRO/g' | \
sed 's/PE NT/PENT/g' | \
sed 's/CHOLR/CHLOR/g' | \
sed 's/ON IDA/ONIDA/g' | \
sed 's/ETH IC/ETHIC/g' | \
sed 's/AS PIR/ASPIR/g' | \
sed 's/RITONA VIR/RITONAVIR/g' | \
sed 's/EUTICA L/EUTICAL/g' | \
sed 's/A CETAM/ACETAM/g' | \
sed 's/DAS E/DASE/g' | \
sed 's/C HLOR/CHLOR/g' | \
sed 's/Z INC/ZINC/g' | \
sed 's/S C VIAL/SC VIAL/g' | \
sed 's/I M VIAL/IM VIAL/g' | \
sed 's/I M AMP/IM AMP/g' | \
sed 's/I V VIAL/IV VIAL/g' | \
sed 's/I V AMP/IV AMP/g' | \
sed 's/ILLI N/ILLIN/g' | \
sed 's/T RIPOL/TRIPOL/g' | \
sed 's/S ODIUM/SODIUM/g' | \
sed 's/DE XT/DEXT/g' | \
sed 's/N APHA/NAPHA/g' | \
sed 's/T ENOF/TENOF/g' | \
sed 's/X\([0-9]\+\) \([0-9.]\+\)/X\1\2/g' | \
sed 's/\([0-9.]\+\) \([0-9.]\+\)MG/\1\2MG/g' | \
sed 's/\([A-Z0-9 ]\)+\([A-Z0-9 ]\)/\1 \/ \2/g' | \
sed 's/   */ /g' > x3.csv

#	Open x3.csv in Excel
#	1. Replace all ! with ,
#	2. Replace all ^ with "
#	3. Save as XSLX
