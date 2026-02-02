program PatientKartotek;

{ Developed by: Vitec Cito A/S

  Description: Ekspedition program

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  26-06-2025/cjs  Change to beregn ordination to handle regel 73,74 (kontanthjælp) as it does with regel 75.
                  Version 7.7.17.0

  20-03-2025/cjs  Change the passing of the bruger number from the programline to handle 4 digits.
                  Previously it was 2 digits.  This means that if the bruger number passed from programline was 112 then
                  it was truncated to 2 digits and therefore set to 11.  Error found in Randers.  Also haffects Gazelle.
                  Version 7.7.16.0

  04-02-2025/cjs  TakserUdenCTR property added.
  04-02-2025/cjs  Regel59 work.
  05-02-2025/cjs  New menu point / action for Takser uden ctr
                  Version 7.7.15.0

  24-07-2024/CJS  Change to UpdatEHord routine to check whether there is match on ordinaton id if the ehordre
                  linier is from a prescription.  This will fix the issue where an ordre has the varenr twice but from 2
                  different prescriptions
                  Version 7.7.14.0

  28-05-2024/cjs  Changed Takserafslut routine to only update the Eordre if there are no
                  more order lines left to process.  This should fix the 5 øre issue
                  Version 7.7.13.0

  15-05-2024/cjs  User pris override for prescription products disabled for now
                  Version 7.7.12.0

  14-05-2024/cjs  Correction to CF6 corrupt screen
                  Version 7.7.11.0

  13-05-2024/cjs  Positivlist
                  New TMJ stock screen
                  Correction to price override when mærkebvare products are on a prescription
                  Version 7.7.10.0

  22-01-2024/cjs  Corrections to faults found during testing at Gazelle.
                  Version 7.7.9.0

  20-11-2023/cjs  Added code to not update total pris on eordre if the calculated total
                  price is within a limit in øre specified by EorderPriceWithinLimits
  20-11-2023/cjs  New property added to main datamodule EorderPriceWithinLimits
                  parameter in winpacer
  20-11-2023/cjs  Added code to warn if taksering not started from Eordre tab (CF8)
  07-12-2023/cjs  Allow prices to be overridden for mærkevare and handkøbsfri even if
                  they are part of a FMK prescription.
                  Version 7.7.8.0

  26-10-2023/cjs  Updated patientkartotek for Gazelle for use with MitId
                  Version 7.7.7.0

  31-05-2023/cjs  Corrected the SendChillkatHttp routine be a function that returned the success or failure
                  Version 7.7.6.0

  26-05-2023/cjs  Update the Eordre using https call.
                  Version 7.7.5.0

  10-02-2023/cjs  Correction to the use of tidlsalgspris and tidlbgp.  The salesprice is only overwritten
                  if the price used would be the salgspris from lagerkartotek and that the order date is
                  not today and the UseEhTidlPris parameter in winpacer is set to Ja
                  Version 7.7.4.0

  02-02-2023/cjs  Replace calls to SendC2ErrorMail with CSS logging
                  Version 7.7.3.0

  01-02-2023/cjs  Allow setting of UseTidlPris under the user section so that individual users can use the
                  tisalgspris and tibgp.
                  Version 7.7.2.0

  19-01-2023/cjs  Corrections for use of prices if Eordre dato is not today.
                  Version 7.7.1.0

  10-08-2022/cjs  Even more efficient sql for DMVS levliste
                  Version 7.7.0.12

  30-06-2022/cjs  Set the value of TakserC2Nr when Takser pressed in Cf8 and set to Zero when finished.
                  Pass the current c2nr into SendEordre routine.
  30-06-2022/cjs  Added property TakserC2Nr for current C2Nr being taksered from CF8 screen
  30-06-2022/cjs  Rewrite UpdateEhord routine to use TakserC2Nr
                  Version 7.7.0.11

  21-02-2022/cjs  Changed Fmkgetmedbyid (used by eordres) to not use consent by default,
                  but if the prescription is  marked as private then try again with consent
                  Version 7.7.0.10

  13-12-2021/cjs  Changes for using the new CtrTilskudSatser table
                  Version 7.7.0.9

  05-10-2021/cjs  Removed the warning about changing AP4 products when taksering
                  Version 7.7.0.8

  21-09-2021/cjs  Corrected fault where autoenter was permanently disabled at the end
                  of the order.
                  Version 7.7.0.7

  20-09-2021/cjs  Roll back autoenter functionality to that in 7.7.0.4.  The other
                  differences in 7.7.0.5 are kept in this version. When taksering the
                  order is complete autoenter is disabled.
                  Version 7.7.0.6

  03-09-2021/cjs  Further amendments to autoenter in takser function.  Auto enter is
                  disabled if the operator edits a line.  Green indicator when
                  order is completed.  User can still add more lines if they wish.
                  Version 7.7.0.5

  26-08-2021/cjs  Corrected check on Fysisk line when checking user discounted price
                  Version 7.7.0.4

  25-08-2021/cjs  Check that ordnations are valid before allowing them to be taksered
  20-08-2021/cjs  Changed FMKGetMedById to check the date validity of the prescription
                  Version 7.7.0.3

  16-08-2021/cjs  Correction to autoenter when taksering eordre.
                  Version 7.7.0.2

  12-08-2021/cjs  Repair dseksp datasource link to mteks
  12-08-2021/cjs  If takser button pressed in cf8 then setfocus on the header grid
  12-08-2021/cjs  Corrected index on EhordreHeader
                  Version 7.7.0.1

  26-07-2021/cjs  Changes for Gazelle
                  Version 7.7.0.0

  01-02-2020/cjs  Correction to receptoversigt.  if the varenr is defined in
                  the prescription then try to et the indeholkfder from
                  generiske.cds using the varenr´, if it fails or the varenr
                  is not supplied then try the drugid. This fixes a issue where
                  the wrong indeolder was displayed / printed
  01-02-2020/cjs  Disabled the undo administration code

                  Version 7.5.9.3

  29-01-2021/cjs  New function to manually undo administrations
                  Version 7.5.9.2

  24-01-2021/cjs  USECHILKAT added to project build parameters
                  Version 7.5.9.1

  13-01-2020/cjs  Removed extra logging of FMK data which is already logged in
                  FMK Classes
  15-01-2021/cjs  Fix to asylansøger not gettings prescriptions under behandling
  15-01-2021/cjs  Fix to asylansøger not setting medicinecard details correctly
                  Version 7.5.9.0

  07-01-2021/cjs  Change ok button in FrmBeskeder to always return Modalresult=mrOK
  07-01-2021/cjs  Change cancel to fortryd in ehandel kvittering screen
  07-01-2021/cjs  in cf8 if user has pressed ok on message screen then send eordre
                  so that the order will be printed
                  Version 7.5.8.9

  06-01-2020/cjs  Change CheckCanOrdinate to not blank Authorisation number the check
                  is not needed
  21-12-2020/cjs  do not send the updated eordre when viewing / updating message
                  Version 7.5.8.8

  15-12-2020/cjs  Changed the check to be on kundenr change rather than navn change
                  which can be different due to middle names etc
                  Version 7.5.8.7

  15-12-2020/cjs  Remove the kundenr has changed messagebox.
                  Version 7.5.8.6

  14-12-2020/cjs  Check fields exist in clientdatasét in savetorseksplinier fixes
                  issue where fields are added to rs_eksplinier like bestilafpatient
                  Version 7.5.8.5

  11-12-2020/cjs  Produktion version after ctr testing
                  Version 7.5.8.4

  09-12-2020/cjs  Save the kundenr in the ctrl-k buffer if the prescription is
                  scanned for taksering.
                  Log and checkbox if kundenr has appeared to have changed after
                  start of taksering process.
                  Version 7.5.8.2

  08-12-2020/cjs  Change konvrseksp to show dosis warning before any prescriptions
                  are handled
  08-12-2020/cjs  Rebuild with Ctr tilskud levels for 2021
                  Version 7.5.8.1

  24-11-2020/cjs  Changed afslutreturnering to always call UpdateDMVS.  This fixes
                  an issue where a partially stregkodekontrolled ekspedition left an
                  item in a dispense/ on hold state in DMVS log
  24-11-2020/cjs  Restext line added to the DMVS reactivate fejl details
                  Version 7.5.8.0

  20-11-2020/cjs  Changed c2kø buttons to be speedbutton so that they do not keep focus
  20-11-2020/cjs  Changed c2kø button captions because speedbutton does not do
                  word wrap and the buttons did not look corrrect.
                  Version 7.5.7.9

  12-11-2020/cjs  Removed checkeordreordinations call in Taksereh
  12-11-2020/cjs  removed messagebox from fmkgetmedbyid as the error message is
                  processed after the call
                  Version 7.5.7.8

  12-11-2020/cjs  Gazelle : if an ordination fails to start effectuation then
                  report more details and move to next line in the order rather than
                  just stop at that point!
                  Version 7.5.7.7

  11-11-2020/cjs  Edifactrcp changed to keep and restore the Eh settings
                  Version 7.5.7.6

  07-11-2020/cjs  change to FMKGetMedById to return error string from StartEffectuation
                  request.
                  Version 7.5.7.5

  29-10-2020/cjs  Modified to use new property for Recepturplads
                  if Recepturplads = DYR then move to dosis combobox from antal field
                  Version 7.5.7.4

  28-10-2020/cjs  Warn about antal changes if the user switches to a product outside
                  the substitution group
  28-10-2020/cjs  reopen Max and Udlev field if antal is less than ordered
                  Version 7.5.7.3

  28-10-2020/cjs  Ensure max and udlev are still disabled if AP4 (etc) product is
                  selected from the same substitution group
  28-10-2020/cjs  Correct email checking when printing kopi faktura
                  Version 7.5.7.2

  28-10-2020/cjs  Check antal bearing in mind substitution list selection
                  Version 7.5.7.1

  28-10-2020/cjs  Only warn if the antal is different providing they have not selected
                  a completely different product.
                  Version 7.5.7.0

  26-10-2020/cjs  Setfocus on Max field if enabled after antal has been keyed.
                  A bevilling was causing an issue with the next field logoc
                  Version 7.5.6.9

  26-10-2020/cjs  Check that the varenr has been switched from the ordineret
                  varenr before warning about antal
                  Version 7.5.6.8

  22-10-2020/cjs  Correction to alias when trying to get C2Q F5Enabled value
                  Version 7.5.6.7

  22-10-2020/cjs  Renamed C2Q F5Disabled parameter to F5Enabled
                  Version 7.5.6.6

  21-10-2020/cjs  Block taksering of dosis eksæpeditions in CF6
                  Version 7.5.6.5

  21-10-2020/cjs  Disabe C2q næste button based on winpacer parameter
  21-10-2020/cjs  Allow download and print dosis ekspedition (blue line)
                  in CF5.  The rs_ekspeditioner and rs_eksplinier are deleted after
                  the print.
  21-10-2020/cjs  VaccinationPopUp=Nej is now the default
                  Version 7.5.6.4

  19-10-2020/cjs  Allow return key to close prescription view screen
                  Version 7.5.6.3

  19-10-2020/cjs  Fixed scrolling on prescription view screen
                  Version 7.5.6.2

  19-10-2020/cjs  Limit the mximum height of the vis RCP screen to 700
  19-10-2020/cjs  Block switch to antal field.  Need to check the
                  rules if the line is not complete yet
                  Versuon 7.5.6.1

  16-10-2020/cjs  PDF test button removed
  16-10-2020/cjs  First attempt to stop cheating on antal field
  16-10-2020/cjs  Make screen the max height allowed on desktop plus initial scroll
                  to show more information.
                  Version 7.5.6.0

  16-10-2020/CJS  PDF Button on CF5 for testing
                  Version 7.5.5.9

  15-10-2020/cjs  correction to etiket lines being deleted if max and udlev fields
                  are disabled.
  14-10-2020/cjs  VaccinationPopUp=Nej in [Receptur] blocks over 65 popup
                  Versiuon 7.5.5.8

  09-10-2020/cjs  make F5 button yellow if antal field yellow + change text of popups
  09-10-2020/cjs  Remove the fee from the bottom of ctr-liste report
  09-10-2020/cjs  Remove the fee from the bottom of ekspedition-liste report
                  Version 7.5.5.7

  09-10-2020/cjs  Check if the varenr has been changed completely from original
                  vare number. if it has and original product was ap4 etc then warn
                  when exiting antal field
                  Version 7.5.5.6

  08-10-2020/cjs  Update mtlinvarenr if the varener is edited during taksering
                  Version 7.5.5.5

  08-10-2020/cjs  Further corrections to udlevnr, udlevmax.  also update ctrtype
                  based on current value from c2getctr. it might have changed!!!
                  Version 7.5.5.4

  07-10-2020/cjs  Correction to CF6 taksering not passing ordineret varenr and antal
  07-10-2020/cjs  Fix tab order on max and udlev fields.  F5 now shows the presciption
                  and then the ordinations oversigt.  Translated messageboxes
                  Version 7.5.5.3

  07-10-2020/cjs  New button to show ordination oversigt, yellow antal + fixes
                  to ap4 etc ordination in takser human screen
                  Version 7.5.5.2

  06-10-2020/cjs  Put the code back in to show selected varenummer for Gazelle
  06-10-2020/cjs  Shift-f5 shows the ordination view screen
  06-10-2020/cjs  Adjust the order of the columns and widen the screen to show more
                  info on ordinations oversigt
                  Version 7.5.5.1

  29-09-2020/cjs  Add the extra info to cf6 taksering to allow the ap4 checks in
                  taksering screen.
  29-09-2020/cjs  New screen that sets up email and printing of fakturas
  29-09-2020/cjs  Block udlev and max fields if AP4, NBS, A or AP4NBS
                  Version 7.5.4.9

  29-09-2020/cjs  Remember the kundenr after taksering for CF5
  29-09-2020/cjs  Code to handle changes to antal and max if product is AP4,NBS or A
  29-09-2020/cjs  Ongoing work to skip email of faktura if betalform is 50 (C2PAY)
                  Version 7.5.4.8


  25-09-2020/CJS  Ehandel messages changed to show product name if the ordination
                  is under behandling
                  Version 7.5.4.7

  24-09-2020/cjs  Ehandel now correctly deals with under behandling ordinations
                  Version 7.5.4.6

  10-09-2020/cjs  Test box is disabled
                  Version 7.5.4.5

  10-09-2020/cjs  Problem when there is no kiundsenr passed from C2KØ. It should do
                  nothing if not in CF1. If in CF1 then point blank kunde and blank
                  out dosis info if needed.  Test box is enabled.
                  Version 7.5.4.4

  09-09-2020/cjs  Blank out MOMSFRI on startup.
                  Version 7.5.4.3

  09-09-2020/cjs  Disable test input box for c2kø testing
                  Version 7.5.4.2

  09-09-2020/cjs  New input box to test kundenr switching from c2kø system.  Fix to
                  error when blank passed from kø system.
                  Version 7.5.4.1

  08-09-2020/CJS  Switch dskar back to ffpatkar when entering CF1 fixes read only error
                  Vewrsion 7.5.4.0

  07-09-2020/cjs  Add logic to show dosiskort warning if user process a fmk prescription
                  If there is no doiscard info and there is a dosisline on the
                  prescription then the usual warning is displayed.
                  Version 7.5.3.9

  03-09-2020/cjs  Further work on c2kø passing kundenr.  Add the praksis name to
                  the cf5 screen
                  Version 7.5.3.8

  28-08-2020/cjs  Fix to code when a message is receied from C2Kø system
                  Version 7.5.3.7

  27-08-2020/cjs  Extra info added to find a C2Kø message issue with switching kundenr
  27-08-2020/cjs  Dont call remove status if the ordination has a lbnr from another
                  session.
                  Version 7.5.3.6

  24-08-2020/cjs  Code removed which replaced Varenr with Ordination varenr in Ehandel
                  Customer has already selected the varenr and this must be honoured.
                  Also the code which updates te eordre lines after the taksering is
                  done matches the varenr bsaed on varenr or subvarenr or ordination
                  varenr.  This fixes issue where extra lines were aded to the eorder
                  because a match was not correctly found and updated.
                  Version 7.5.3.5

  17-08-2020/cjs  Change to cf5 screen to allow the remova status call on prescription
                  without cprnr.
                  Version 7.5.3.4

  13-08-2020/cjs  Change to dosisgrid to be grey line for 'i bero'.
                  Removed the column for 'i bero'
                  Also when cf1 is reentered if the kundenr has changed then the dosis
                  grid info is refreshed
                  Version 7.5.3.3

  12-08-2020/cjs  report to c2fmkkø all retur ekspeditioner not just those that
                  are afsluttet
                  Version 7.5.3.2

  11-08-2020/cjs  Added packing group name to dosis card information
                  Version 7.5.3.1

  10-08-2020/cjs  return result true if patient is not digits which means that taksering
                  is allowed
                  Version 7.5.3.0

  10-08-2020/cjs  Changed call to get dosis info so only 10 digit kundenr are accepted
                  Version 7.5.2.9

  10-08-2020/cjs  Changed last gebyr date format to be dd-mm-yy
  10-08-2020/cjs  Removed code for updating dosis yder/cprnr info on doiskorts
                  Version 7.5.2.8

  07-08-2020/cjs  Report error if lager does not exist in OpdaterLager function
                  Version 7.5.2.7

  05-08-2020/cjs  Removed code for taksering blank cpr in CF6.
                  Version 7.5.2.6

  03-08-2020/cjs  Added check for varenr 100030 and 680018 for gebyr numbers
                  Work with blank CPR number (in progress)
                  Version 7.5.2.5

  29-07-2020/cjs  Changed text for prómpt if there is no cpr nr in CF6 taksering
                  Version 7.5.2.4

  28-07-2020/cjs  Removed check on blank cpr in remove status action in CF5 CTRL-Alt-R
                  Version 7.5.2.3

  24-07-2020/cjs  New sql to look for gebyr in ekspliniersalg for varenr 688017
                  Version 7.5.2.2

  22-07-2020/cjs  Correction to fqlevliste sql.
                  Version 7.5.2.1

  21-07-2020/cjs  Only call check ctr update if kunetype =1
  21-07-2020/cjs  Added routine to check where the dosiscard is being handled at a
                  lokation mentioned in RS_Settings
                  Version 7.5.2.0

  17-07-2020/cjs  Removed code to get dosiscard innfo from afterscroll event
  17-07-2020/cjs  Handle exception when getting dosis info for non fmk patients
                  Added call to C2getctr if new patient added during FMK taksering
  17-07-2020/cjs  Added ffpatkar refresh to ensure latest data available.
                  Version 7.5.1.9

  12-07-2020/CJS  Changed dosis information on main screen to be that from FMK
  12-07-2020/CJS  Redesigned the dosis warning screen to use info from FMK
  12-07-2020/cjs  Added PatientDosisCards for use in dosis info screens
                  Version 7.5.1.8

  16-06-2020/MA   Resized first panel in status panel to allow the whole Brugernr. to be shown in certain screen setups.

  04-05-2020/cjs  Use the VisRecepterCF6 property to show the number of days in CF6
  04-05-2020/cjs  Add a property for the number of days to search in CF6 (default 60)
                  Version 7.5.1.7

  04-05-2020/cjs  If the cprnr number changes or they go back to cf6 then reset the date interval
  04-05-2020/cjs  Use TC2Vareident in vare field in taksering screen so that varenr and various
                  forms of barcode are processed correctly.
                  Version 7.5.1.6

  01-05-2020/cjs  Block the crediting of dosis ekspedition created using FMK dosis program
                  Corrected CheckEordreOrdinations to use the kundenr from the EOrdre for calls to
                  FMK.
  01-05-2020/cjs  removed th ' character from earch text in substitution screen
                  Version 7.5.1.5

  28-04-2020/cjs  Change udskrivetiket message to stop etiket printing spamming central log
  28-04-2019/cjs  More efficient sql for DMVS levliste
                  Version 7.5.1.4

  27-04-2020/cjs  if the doctor name on the header is blank then overwrite it with issuertitel from
                  the fmk ordination in ehandel orders
                  Version 7.5.1.3

  23-04-2020/cjs  CtrBevillinger screen fires c2getctr for latest info
                  Konvdoskort changed prompt to allow taksering of a single card if the user accepts
                  the messagebox.  in addition pakkegruppe taksering is not allowed if the card
                  exists in FMK dosiskort system
                  Eordre taksering now gets the doctor name
  23-04-2020/cjs  Declared CTRBevOvr as class procedure and removed from autocreate
  23-04-2020/cjs  Fixed access violation if getmeds by id fails due to exeception
                  Version 7.5.1.2

  21-04-2020/cjs  remnoved check for CheckEordreOrdinations logic for gazelle.
                  Requires more testing.
  21-04-2020/cjs  Improved searching using navn index better
                  Versiobn 7.5.1.1

  15-04-2020/cjs  Changed konvdoskort to use the correct consent according to the value of privat
                  field in rs_ekspinier
  15-04-2020/cjs  get the correct afdelingsnavne for the report
  14-04-2020/cjs  Correction to iteration number in Ordnationsoversigt
  14-04-2020/cjs  Improve searching in CF6 limit date to max 60 days
                  Version 7.5.1.0


  14-04-2020/cjs  Added exception handling around the deletion and creation of blank customer
                  Version 7.5.0.9

  08-04-2020/cjs  if BEGR – Atckode J01FA10 message displayed then dont show the usual message
                  Version 7.5.0.8

  08-04-2020/cjs  Moved BEGR – Atckode J01FA10 message to point where the user has entered the varenr
                  Version 7.5.0.7

  08-04-2020/cjs  Udlev BEGR – Atckode J01FA10 messagechanged to yes no box in taksering screen
  06-04-2020/cjs  Only write to rs_ekspqueue if kundetype is enkeltperson (1)
                  Ehandel work for gazelle that will make sure any fmk prescriptions are set to
                  ekspedition påbegyndt before taksering.
  02-04-2020/cjs  added check if drug.identifier is assigned.   Removes the access violation reported
                  in central log
  02-04-2020/cjs  Fejl i Lægens navn text replace with Udsteders navn skal angives ved afslutning af manuelle recepter.
                  Version 7.5.0.6

  01-04-2020/cjs  report the credit to C2fmkkø  not the original ekspedition number.  This allows
                  the correct bruger to log in.  C2fmkkø wil work out with ekpedition is the
                  original ekspedition and work through all credits correctly.
                  Version 7.5.0.5

  01-04-2020/cjs  removed the message 'direkte forhandlet' from the printing of the prescription.
                  Version 7.5.0.4

  30-03-2020/cjs  KeepReceptLokalt property added. if set to Nej then locsl copy of prescription
                  is kept if removestatus is called
                  Version 7.5.0.3

  25-03-2020/cjs  Do not close the connect to kassedk for printing etikets.  keeps 1 socket open
                  all the time and avoids the time_wait issue
                  Version 7.5.0.2

  23-03-2020/cjs  Rebuild to use new routinne that fixes issues with socket usage.  Also moved the
                  code that check is a user is logged in to datamodule that runs every 15 seconds.
                  Also amended dosiskort check (currently commented out)
                  Version 7.5.0.1

  22-03-2020/cjs  Change drawpanel to not check the certificate of a user but if bruger<> 99 then
                  orange else grey. stops the program hittinbg the adgangserver too much
                  Version 7.5.0.0

  19-03-2020/cjs  Popup the reasontext if starteffectuation fails
                  Version 7.4.9.9

  19-03-2020/cjs  Use ansipos to check måned is specified in udlebv interval in cf5
                  Version 7.4.9.8

  18-03-2020/cjs  Popup a warning if scanned receptkvittering does not exist
                  Version 7.4.9.7

  18-03-2020/cjs  Valid cpr number changed to allow cprnr  > 010100-0000 and < 400000-0000
                  Version 7.4.9.6

  16-03-2020/cjs  Add the Receptid to invalidate call so we point at the correct line
                  Version 7.4.9.5

  13-03-2020/cjs  Fix to strange error in Christianshavn.  report the fmk error message when starting
                  an ordination.
                  Version 7.4.9.4

  09-03-2020/cjs  Before BestiltAf is populated, it is ensured that the organisation/person is neither an Apotek,
                  Apoteker, Apoteksansat, nor a Behandlerfarmaceut so we prevent confusion when printing prescriptions.
                  Copied from C2HentAdresseret
                  Version 7.4.9.3

  27-02-2020/cjs  Do not allow selection of prescription in cf5 if its ekspedition påbegynd
                  Version 7.4.9.2

  26-02-2020/cjs  remove status on any prescriptions that were succesfully  set under behandling
                  if the list of failed is not empty
                  Version 7.4.9.1

  26-02-2020/cjs  return false if Starteffectuation does not work
  26-02-2020/cjs  Created a list of invalid id's and report this if not empty
                  Version 7.4.9.0

  24-02-2020/cjs  Use the PatPersonIdentifier and source when terminating a prescription
                  Version 7.4.8.9

  21-02-2020/cjs  Corrected olor in cf6 if prescription chosen by spacebar
  21-02-2020/cjs  Blank out authorisation number if the prescripyion does not need it
                  Version 7.4.8.8

  21-02-2020/cjs  CF6 buttons now being passed the PatCPr/PatPersonIdentifier field from rs_ekspeditioner
  20-02-2020/cjs  Changed ProcessPrescriptionsForPersonOrOrganisation to only update fields for order
                  that is bestilt.
                  Version 7.4.8.7

  18-02-2020/cjs  Refresh bottom part of cf6 after afslut pressed
                  Version 7.4.8.6

  18-02-2020/cjs  Warning on cf6 buttons if no cprnr
                  Version 7.4.8.5

  18-02-2020/cjs  print udlev information if repeat prescription.
  18-02-2020/cjs  Add the varenr column to CF5
                  Version 7.4.8.4

  14-02-2020/cjs  Correct validation of cpr number in cf5
                  Version 7.4.8.3

  12-02-2020/cjs  Only extract numeric personid
                  Version 7.4.8.2

  12-02-2020/cjs  Fix to function that extract PersonId correctly
                  Version 7.4.8.1

  12-02-2020/cjs  Added function to extract PersonID correctly
                  Version 7.4.8.0

  11-02-2020/cjs  Fix to sql after user logs in.
                  Version 7.4.7.9

  11-02-2020/cjs  When i user logs in it checks if there is anything in the fejl queue with the
                  current bruger is either the takser or the afslut bruger. if there is then they
                  are automatically resubmitted to C2FMKKø.
  11-02-2020/cjs  added repaint of status bar to 10 second timer.  also dpanel is set to double
                  buffer to avoid flicker
  11-02-2020/cjs  Show bruger afslut column and all ret on 4202 to resubmit with reported by current
                  bruger (like 1 does)
                  Version 7.4.7.8

  10-02-2020/cjs  Check 1st 6 digits of cprnr are a valid date
  10-02-2020/cjs  Enable Ret button for 109 and 851
                  Version 7.4.7.7

  10-02-2020/cjs  Check current bruger has a certificate before all fmk calls.  if sucessfully login
                  then update screen to say that else logout of program
                  Better validation of CF5 kundenr number
                  Version 7.4.7.6

  05-02-2020/cjs  Ret button now will allow function if sygehus is not valid
                  Version 7.4.7.5

  05-02-2020/cjs  Enable ret button if invalid sygehus nummer
                  Warning if etiket changed and the ekaspedition was afsluttet.
                  Version 7.4.7.4

  04-02-2020/cjs  only set in progress if patient exists.
                  Version 7.4.7.3

  03-02-2020/cjs  Commented out code for Tilbage ekspedition that checked it was an fmk dosiskort
                  Version 7.4.7.2

  03-02-2020/cjs  Add date to search results for prescriptions without cprnr
  03-02-2020/cjs  Disable dosis check for fmk dosiskort
                  Version 7.4.7.1

  03-02-2020/cjs  Use the patient number in PatPersonIdentifier if there is data there
                  Version 7.4.7.0

  01-02-2020/cjs  Copy the processing of a prescription from C2hentaddresseret to incoroprate the
                  new patient and organisation fields (used for kundenr with valid cpr)
                  Version 7.4.6.9

  30-01-2020/cjs  Check FMKCertifikatLogon=Nej parameter in user segment to allow entry into program
                  without a certificate
                  Version 7.4.6.8

  29-01-2020/cjs  Save the ektra bestil info in rs_eksplinier if modified by segment is available
                  from FMK
  29-01-2020/CJS  Do not allow the tasering of dosis cards that are part of FMK solution
  29-01-2020/CJS  added afdelingnr parameter to SendRCPRapport
                  Version 7.4.6.7

  23-01-2020/cjs  Fixed error that did not enable ret button correctly in FMK Fejl screen
                  Version 7.4.6.6

  22-01-2020/cjs  Changed text on question after slet button
  22-01-2020/cjs  Print the ordination id and add prefix 'Bestilt af:'
                  Version 7.4.6.5


  22-01-2020/cjs  Enable ret button if fmk error is 107 and 'er ikke et gyldigt ydernummer'
  22-01-2020/cjs  Enable ret button if fmk error is 119332 (bad authorisation number)
  22-01-2020/cjs  bold the "bestiltaf" message on the print of the prescription
                  Version 7.4.6.4

  22-01-2020/cjs  Correct afdeling navn on the receptoversigt report
  21-01-2020/cjs  Correction to iterationcount if it is 0
                  Version 7.4.6.3

  21-01-2020/cjs  Do not increase interationcount by 1
                  Version 7.4.6.2

  16-01-2020/cjs  Swap build name and number
                  Version 7.4.6.1

  16-01-2020/cjs  Display / print building number and middle names in CF5 search and receptoversigt
                  Version 7.4.6.0

  16-01-2020/CJS  Update error text in search prescripTions CF5
                  Version 7.4.5.9

  15-01-2020/cjs  Search prescriptons fix to null date + translation of english popups
                  Version 7.4.5.8

  15-01-2020/cjs  Changd print function of Receptoversigt to send a copy of the print displayed
                  on screen rather than get midsrv program to to use fmk calls itself
                  Version 7.4.5.7

  14-01-2020/cjs  Do not check ydernavn if udligning
                  Version 7.4.5.6

  14-01-2020/cjs  Use new Drug.DrugName property
  14-01-2020/cjs  Do not prompt for dosering / indikation if udligning.
                  Version 7.4.5.5

  13-01-2020/cjs  Added  exception handling to Indhold info
                  Version 7.4.5.4

  13-01-2020/CJS  Remove unwanted calls to GetCTR
                  Version 7.4.5.3

  08-01-2020/cjs  Print ordination id on prescription (used by dosis users)
                  Add hh:mm:ss to ordination dato
  08-01-2020/CJS  Show the ordination id on the print (dosis users need this)
  08-01-2020/cjs  Set SaveCPR to ACPRNr passed in procedure call.
                  Version 7.4.5.2

  06-01-2020/cjs  Corrected receptstatus to 5 to avoid issues ith C2Hentadresseret
                  Version 7.4.5.1

  06-01-2020/cjs  First release of FMK version.
                  Version 7.4.5.0

  15-10-2019/cjs  Update ctrsaldo in eordre from ekspliniertilskud even if the product has been
                  substituted
                  Version 7.3.1.7

  11-10-2019/cjs   Get the latest ctrsaldo from last ekspliniertilskud rather than from the
                   ekspedtioner record. This is necessary due to Cannabis change
                  Version 7.3.1.6

  09-10-2019/cjs  Update the ctr values after each line in the pakkelist for eordre
                  Force the udlevdmvs window to stay on top
                  Version 7.3.1.5

  03-10-2019/cjs  After all dmvs products have been checked we need to get the full list of lbnr in
                  the leveringsliste for the zero bon.
                  Version 7.3.1.4

  24-09-2019/cjs  Changed sql to only handle the lbnr that have an entry in dmvslog in UdlevDMVS
                  Version 7.3.1.3

  24-09-2019/cjs  remove check on 80xxxx numbers to allow reservation
                  Version 7.3.1.2

  11-09-2019/cjs  Corrected mteks kundenavn error on startup.
                  Version 7.3.1.1

  10-09-2019/cjs  use the kundenavn specified at the start of taksering
                  Version 7.3.1.0

  02-09-2019/cjs  reset the dk flag always in case the antal fielsd is reentered for some reason
                  Version 7.3.0.9

  29-08-2019/cjs  only check the udlevnr if the SpørgUdlA parameter in winpacer is set to Ja (default is Ja)
  28-08-2019/cjs  increased timeout on cf3 sql top display ekspeiditioner for kundenr in cf1 to 30
                  seconds kundenr 90 takes longer than 10 seconds to display
                  Version 7.3.0.8

  28-08-2019/cjs  Changed sql that displays the "open" levlistes to check for a matching entry in
                  DMVSLog table
                  Version 7.3.0.7

  12-08-2019/cjs  Danish tekst for popup in CF5 takser
                  Version 7.3.0.6

  12-08-2019/cjs  BusyMouseBegin and BusyMouseEnd implemented in CF5 Takser
                  Version 7.3.0.5

  12-08-2019/cjs  make sure any of the ordination id are not waiting in CF6 when takser button
                  pressed in cf5
                  Version 7.3.0.4

  05-08-2019/cjs  EscapePressedInDMVS boolean property added
                  Version 7.3.0.3

  01-08-2019/cjs  Only point at the correct patient if not blank from Receptserver
                  Version 7.3.0.2

  01-08-2019/cjs  Introduced DifferentLager to check whether we should ask the question
                  Version 7.3.0.1

  01-08-2019/cjs  removed refresh on ffeksovr in tilbagefør function in cf3
                  Version 7.3.0.0

  25-07-2019/cjs  if processing a prescription then point at the correct patient if ffpatkar before
                  showing the screen
                  Version 7.2.9.9

  25-07-2019/cjs   Always get the current patient record from the ekspedition when saving an
                   ekspedition.
                  Version 7.2.9.8

  25-07-2019/cjs  More testing for goAuto flag
                  Version 7.2.9.7

  24-07-2019/cjs  Check goAuto flag if issue with patient from rs_ekspeditioner if there is an issue
                  with the patient.  This is only affect if the Afslut_i_CF5_CF6 parameter is set to Ja
                  Version 7.2.9.6

  24-07-2019/cjs  Added DisableCPRModuloCheck to Receptur segment of winapacer (default Nej). All
                  places where CheckCPrNr is called check the parameter first.
                  Version 7.2.9.5

  24-07-2019/cjs  Added ? to Ønsker du at fortsætte
                  Version 7.2.9.4

  23-07-2019/CJS  corrections fixes made in 7.2.9.2
                  Version 7.2.9.3

  19-07-2019/cjs  Restrict search to current lager.  Sagsnr 10241
  19-07-2019/cjs  Sagsnr 10198. popup if lager on ekspedition is not current lager when doing a return
  19-07-2019/cjs  Sagsnr none.  if adding a debitor to a patient then do not display MOMSFRI
  19-07-2019/cjs  Sagsnr 10310.  Replaced chkbox with new chkbox (need to click ok) to fix issue
                  with substitution combo box
  19-07-2019/cjs  Sagsnr 10289. Warn if udlevtype AP4NB like it does if AP4
  19-07-2019/cjs  Sagsnr 10388.  If max > udlev then pop on certain udlevtypes
                  Version 7.2.9.2

  12-07-2019/cjs  Fix to ap4 ceck for skibsfører
                  Version 7.2.9.1

  11-07-2019/cjs  Corrected ap4 check for skibsfører and allowed 4000000103 as valid ydercprnr
                  Version 7.2.9.0

  11-07-2019/cjs  extra logging added to find skibskiste aurthorisation number issue
                  Version 7.2.8.9

  08-07-2019/cjs  Escape key code added to frmDMVS.new message allowing the press of escape to
                  quit the screen
                  Version 7.2.8.8

  04-07-2019/cjs  Correction to sql in checking udbrgebyr
                  Version 7.2.8.7

  03-07-2019/cjs  if sendre is a lokation number then replace with Fxxxxxx where
                  xxxxxx is the autnr prefix with zeroes if necessary
                  Version 7.2.8.6

  02-07-2019/cjs  If product is classified as dmklDMVSVare2DKrav then the 2d barcode must be scanned

  25-06-2019/cjs  Added code to handle lokationsnummer instead of ydernr in receptserver ordnation in
                  CF6 screen.
                  Version 7.2.8.5

  24-06-2019/cjs  Added logging to RecvCtrFiktiv in midclientapi.
                  Version 7.2.8.4

  21-06-2019/cjs  Added code to handle lokationsnummer instead of ydernr in receptserver ordnation
                  Version 7.2.8.3

  13-06-2019/cjs  Correction to start saldo's on faktura and pakkesddel.
                  Version 7.2.8.2

  12-06-2019/cjs  corrected takserhuman to update start saldos if changed by c2getctr
                  Version 7.2.8.1

  29-05-2019/CJS  opdaterlagereksp call checks on AppResConError(6) and retries, also the timeout
                  for the call is reset to 30 seconds
                  Version 7.2.8.0

  29-05-2019/CJS  opdaterlagereksp call checks on AppResConError(6) and retries, also the timeout
                  for the call is reduced to 10 seconds
                  Version 7.2.7.9


  22-05-2019/cjs  reset the reservation grossist list to the first grossist again in case it has
                  been changed during the ekspedition
                  Version 7.2.7.8

  21-05-2019/cjs  dmvs not enabled on the afdeling so use the global connection
                  Version 7.2.7.7

  10-05-2019/cjs  Old code to be replaced by a new sql that will stop issue with the
                  current cursor in nxREksplin being trashed by other procedure
                  such as viewing a prescription whilst waiting for the answer from receptserver
                  Version 7.2.7.6

  06-05-2019/cjs  Change tekst on lms32 etiket to Flere mindre pakninger er billigere
                  Version 7.2.7.5

  06-05-2019/cjs  remove antpkn=0 from sl_Sql_lms32_label
                  Version 7.2.7.4

  06-05-2019/cjs  correction to subst label sql link varenr in lagerkartotek to subnr in
                  lagersubstliste
                  Version 7.2.7.3

  03-05-2019/cjs  Corrections to subst label sql's
                  Version 7.2.7.2

  02-05-2109/cjs  Correction to total in momsfri faktura. It did not include gebyr before
                  Check to see if whole line credited. if it is then dont ask to scan each package
                  Version 7.2.7.1

  30-04-2019/cjs  Use the correct DMVS info in full retur when updaingold lbnr eksplinierserienumre
                  Version 7.2.7.0

  30-04-2019/cjs  Bug fixes re ReturTidspunkt in eksplinierserienumre
                  Version 7.2.6.9

  30-04-2019/cjs  Correction sql to update ReturTidspunkt in eksplinierseriumre + copy code into full
                  return of an ekspedition
                  Version 7.2.6.8

  30-04-2019/cjs  New field returtidspunkt in eksplinierserienumre
                  only erquest scan for minimum of atal returned ansd antal scanned DMVS products
                  Version 7.2.6.7

  29-04-2019/cjs  Use CurrentDMVS connection t be created if afdnr is different and free it if created
                  also added exception handling to cope with error when processing UpdateDMVS
                  Version 7.2.6.6

  26-04-2019/cjs  Corrected sql in Checkalreadyscanned
                  Version 7.2.6.5

  26-04-2019/cjs  Create a local new TC2DMVSSrvConnection if the original ekspedition was done in a
                  different afdeling from the curren afdeling.
                  Version 7.2.6.4

  25-04-2019/cjs   Only request scans for those products that have been 2d scanned when returning
                   part of an ekspedition
                   Version 7.2.6.3

  24-04-2019/cjs  if a product has not been scanned before then dont ask them to scan it when
                  returning. if returning whole ekspedition just write the line back if not full
                  DMVS scan
                  Version 7.2.6.2


  24-04-2019/cjs  Changed getpharmacyname in ctr. ekspeditinsiste to handle apoteksnr with less
                  than 5 digits
                  Version 7.2.6.1

  23-04-2019/cjs  Always use updated ctr valies dfrom c2getctr for line 1.  Previously it did not
                  update ctr values if update time was less than 15 since last update.  This resulted
                  in Udligning issues
                  Version 7.2.6.0

  17-04-2019/cjs  Report error when scanning a reactivated package. Change title of report.
                  Version 7.2.5.9

  17-04-2019/cjs  Look at all lbnr in faktura and pakkelist to get start ctr values
                  Version 7.2.5.8

  16-04-2019/cjs  Save the correct start saldo for udligning in the header record
                  Version 7.2.5.7

  15-04-2019/cjs  Set the CTRBordination flag in udligning code
                  Version 7.2.5.6

  15-04-2019/cjs  Report ctr a and b levels for udligning as well
                  Version 7.2.5.5

  12-04-2019/cjs  new format for the udligning grid
                  Version 7.2.5.4

  11-04-2019/cjs  Get ctr saldo from herader record for udligning ekspeditions rather than using
                  the zero filled ekspliniertlskud records
                  Version 7.2.5.3

  10-04-2019/cjs  only print batch info if kundetype is correct on faktura
                  new 2 line text message in vare field during taksering
                  dont set the brugerkontrol to takserbruger if whole eklspedition is credited
                  Version 7.2.5.2

  09-04-2019/cjs  update english message with danish tekst in takserhuman evare enter event
                  further changes to text
                  Version 7.2.5.1

  09-04-2019/cjs  update english message with danish tekst in takserhuman evare enter event
                  Version 7.2.5.0

  09-04-2019/cjs  Dont allow change of varenr if the line has already updated the header ctr
                  Version 7.2.4.9

  08-04-2019/cjs  Corrected ctr calculation in takser human and print uddato as string instead of
                  date
                  Version 7.2.4.8
  05-04-2019/cjs  Tostring changed to AsStrign in sql insert
                  Version 7.2.4.7

  05-04-2019/cjs  put quotes around strings for sql inserts
                  Version 7.2.4.6

  05-04-2019/cjs  Add an entry in eksplinierserienumre for all entries on the orignal  salg ekspedition
                  Version 7.2.4.5

  26-03-2019/cjs  Added Returdage persistent field to fqeksovr for display in CF3
                  Changed tlf gebyr tekst to edb gebyr on etiket
                  corrected the printing of returdate on pakkelist and faktura
                  Version 7.2.4.2

  25-03-2019/cjs  7.2.4.1 pressing enter in vare field with blank caused random vare to be selected

  25-03-2019/cjs  7.2.4.0 wrong calculation of udbrgebyr uden moms

  22-03-2019/cjs  7.2.3.9 use gebyr properties for comparsion based on inclmoms on each line

  22-03-2019/BN   7.2.3.8 VAT problems with TlfGebyr, EdbGebyr and UdbrGebyr.

  20-03-2019/BN   7.2.3.7 Changed Name to Vitec Cito and added comments to edited units
                          LaserFormularer:
                            Added PrisExMoms and BruttoExMoms to mtDetail
                            Added ExMoms to mtMaster
                          UdskrivFakturaLaser:
                            Using PrisExMoms and BruttoExMoms in mtDetail
                            Using ExMoms in mtMaster
                          TakserLeverencer:
                            Remove recepturgebyr if HA håndkøbslinier before moms calculation
                            (Codelines moved to place before moms calculation)

  27-11-2018/cjs  7.1.6.5 set and use ReturDage on ekspeditioner for DMVS +
                          FDosispakkegebyrVarenr := C2StrPrm('Receptur','DosispakkegebyrVarenr','688002');

  27-11-2018/cjs  7.1.6.4 add varenavn to doseringsetiket for skanderborg vet

  31-10-18/cjs    7.1.6.3 fixed danish characters in dm.pas

  31-10-18/cjs    7.1.6.2 fixed brevnr field

  25-10-18/cjs    7.1.6.1 added antal to vis rcp kontrol screen

  10-09-18/cjs    7.1.5.8 correction to null pakkelist to aklways print dmvs retur days

  07-09-18/cjs    7.1.5.7 fix to vareident create to pass true to get the lager details + fix
                          to afdeling number in call  to DMVS datasnap server

  06-09-18/cjs    7.1.5.5 extra logging for dmvs products reutrn days

  17-08-18/cjs    7.1.5.3 fix issue where ordination can be left under behandling if the same
                          receptkvittering is scanned again for other non completed ordinations

  27-07-18/cjs    7.1.5.2 sagsnr 10484,10515, fix pakkelst to print correct round values

  17-07-18/cjs    7.1.5.1 dosishkbgebyr fix, english message translated to danish + gazelle changes

  01-12-2017/cjs  7.0.6.9  2018 CTR Tilskud levels.

}

// comment

uses
  PrevInst,
  Dialogs,
  Forms,
  sysutils,
  RPDefine,
  C2Splash,
  Midaslib,
  PostnrLST in '..\..\XE7\Apotek\Common\PostnrLST.pas' {PnLstForm},
  DM in 'DM.pas' {MainDm: TDataModule},
  PatientLst in '..\..\XE7\Apotek\Common\PatientLst.pas' {PaLstForm},
  YderLst in '..\..\XE7\Apotek\Common\YderLst.pas' {YdLstForm},
  InstLst in 'InstLst.pas' {InLstForm},
  TakserAfslut in 'TakserAfslut.pas' {AfslutForm},
  ReRecept in 'ReRecept.pas' {ReRcpForm},
  SoegRecept in 'SoegRecept.pas' {SoegRcpForm},
  RegelLst in 'RegelLst.pas' {ReLstForm},
  CtrBevilling in 'CtrBevilling.pas' {fmCtrBevilling},
  MidClientApi in '..\..\XE7\Apotek\Common\MidClientApi.pas' {MidClient: TDataModule},
  HentHeltal in 'HentHeltal.pas' {fmTastHeltal},
  FriDosEtiket in 'FriDosEtiket.pas' {EtiketForm},
  HentFraTilDato in 'HentFraTilDato.pas' {FraTilDatoForm},
  KommuneAfregning in 'KommuneAfregning.pas' {KommuneForm},
  HentFraTilDatoTid in 'HentFraTilDatoTid.pas' {FraTilDatoTidForm},
  C2Tastatur in '..\..\XE7\Apotek\Common\C2Tastatur.pas' {TastaturForm},
  TakserLeverancer in 'TakserLeverancer.pas' {LeveranceForm},
  UdskBevillinger in 'UdskBevillinger.pas' {UdskBevForm},
  C2MainLog in '..\..\XE7\Apotek\Common\C2MainLog.pas' {MainLog: TDataModule},
  SletMedkort in 'SletMedkort.pas' {SletMedkForm},
  UdlignCtr in 'UdlignCtr.pas' {CtrUdlignForm},
  HentTekst in 'HentTekst.pas' {fmTastTekst},
  UdskrivPakkeLaser in 'UdskrivPakkeLaser.pas' {fmPakkeLaser},
  UdskrivFakturaLaser in 'UdskrivFakturaLaser.pas' {fmFakturaLaser},
  VisInteraktion in 'VisInteraktion.pas' {fmInteraktion},
  DebitorLST in '..\..\XE7\Apotek\Common\DebitorLST.pas' {DeLstForm},
  BevillingsOversigt in 'BevillingsOversigt.pas' {BevillingsForm},
  CtrBevOversigt in 'CtrBevOversigt.pas' {fmCtrBevOversigt},
  UbiPrinter in '..\..\XE7\Apotek\Common\UbiPrinter.pas' {fmUbi: TDataModule},
  VareReservation in '..\..\XE7\Apotek\Common\VareReservation.pas' {frmRes},
  SubstOversigt in 'SubstOversigt.pas' {SubstForm},
  frmEkspLin in 'frmEkspLin.pas' {frmRetLin},
  C2SqlScripts in '..\..\XE7\Apotek\Common\C2SqlScripts.pas',
  uRowaAppCall in 'uRowaAppCall.pas' {frmRowaApp},
  uRCPMidCli in 'uRCPMidCli.pas' {RCPMidCli: TDataModule},
  frmLagerList in 'frmLagerList.pas' {frmDebLagListe},
  frmKomLst in 'frmKomLst.pas' {frmKomEanLst},
  uCPRlist in 'uCPRlist.pas',
  uOrdView in 'uOrdView.pas' {frmOrdView},
  uRCPTidy in 'uRCPTidy.pas' {frmRCPTidy},
  RCPPrinter in 'RCPPrinter.pas' {RCPPrnForm},
  uRowaUdtag in 'uRowaUdtag.pas' {frmRowaUdtag},
  uYesNo in 'uYesNo.pas' {frmYesNo},
  uGebyr in 'uGebyr.pas' {frmGebyr},
  uFejl in 'uFejl.pas' {frmRcpKont},
  uVisEkspFejl in 'uVisEkspFejl.pas' {frmVisEkspKontrol},
  uOpdCTR in 'uOpdCTR.pas' {frmOpdCTR},
  uVaelgLevliste in 'uVaelgLevliste.pas' {frmVaelgLevliste},
  uKundeOrd in 'uKundeOrd.pas' {frmKundeOrd},
  uDebKontrol in 'uDebKontrol.pas' {frmDebKont},
  frmDosis in 'frmDosis.pas' {frmDosiskort},
  PatMatrixPrinter in 'PatMatrixPrinter.pas' {PatMatrixPrnForm},
  TakserHuman in 'TakserHuman.pas' {HumanForm},
  uArkivKunde in 'uArkivKunde.pas' {frmArkivKunde},
  uDosCard in 'uDosCard.pas' {frmDosKort},
  uResv in 'uResv.pas' {frmResv},
  Main in 'Main.pas' {StamForm},
  ufrmBeskeder in 'ufrmBeskeder.pas' {frmBeskeder},
  ufrmKvittering in 'ufrmKvittering.pas' {frmKvittering},
  ufrmStatus in 'ufrmStatus.pas' {frmStatus},
  uRCPSearch in 'uRCPSearch.pas' {frmRCPVare},
  uNomStk in 'uNomStk.pas' {frmNomecoStk},
  DSFileclasses in '..\..\XE7\Apotek\Common\DSFileclasses.pas',
  SendSMS in '..\..\XE7\Apotek\Common\SendSMS.pas' {frmSendSMS},
  uSMSMethods in '..\..\XE7\Apotek\Common\uSMSMethods.pas',
  TakserDosis in 'TakserDosis.pas' {TakserDosisForm},
  MatrixClassesu in '..\..\XE7\Apotek\Common\MatrixClassesu.pas',
  DSPrintu in '..\..\XE7\Apotek\Common\DSPrintu.pas' {DMDSPrinter: TDataModule},
  SMSDMu in 'SMSDMu.pas' {SMSDM: TDataModule},
  C2Qtnsu in 'C2Qtnsu.pas' {frmC2Q},
  C2Qbtnframeu in 'C2Qbtnframeu.pas' {C2QFrame: TFrame},
  PIBVarNomu in 'PIBVarNomu.pas' {frmPIBNom},
  PIBvARtmjU in 'PIBvARtmjU.pas' {frmPIBVarTMJ},
  RSEkspFejlu in 'RSEkspFejlu.pas' {frmRSEkspFejl},
  BonPrinter in 'BonPrinter.pas' {PrintForm: TDataModule},
  frmHenstandsOrdning in 'frmHenstandsOrdning.pas' {FmHenstandsOrdning},
  uC2GenericPrinter in '..\..\XE7\Apotek\Common\uC2GenericPrinter.pas',
  uC2GenericPrinter.Classes in '..\..\XE7\Apotek\Common\uC2GenericPrinter.Classes.pas',
  BeregnOrdinationu in 'BeregnOrdinationu.pas',
  DMPrintDosCard in 'DMPrintDosCard.pas' {PrintDosCardDM: TDataModule},
  CtrTilskudsSatser in '..\..\XE7\Apotek\Common\CtrTilskudsSatser.pas',
  frmC2VareMiniInfo in '..\..\XE7\Apotek\Common\frmC2VareMiniInfo.pas' {FormC2VareMiniInfo},
  ufrmDVMS in 'ufrmDVMS.pas' {frmDMVS},
  BeregnDosisOrdinationu in 'BeregnDosisOrdinationu.pas',
  BeregnUdlignOrdinationu in 'BeregnUdlignOrdinationu.pas',
  BeregnCannabisOrdinationu in 'BeregnCannabisOrdinationu.pas',
  uCTRUdskriv in 'uCTRUdskriv.pas' {frmCTRUdskriv},
  uEkspUdsriv in 'uEkspUdsriv.pas' {frmEkspUdskriv},
  uUdlevDMVSLevliste in 'uUdlevDMVSLevliste.pas' {frmUdlevDMVS},
  OpdaterKonti in 'OpdaterKonti.pas' {KontoFraTilForm},
  uEDIRcp.classes in 'uEDIRcp.classes.pas',
  frmC2Logon in '..\..\XE7\Apotek\Common\frmC2Logon.pas' {FormC2Logon},
  uFMKGetMedsById in 'uFMKGetMedsById.pas',
  uFMKCalls in 'uFMKCalls.pas',
  ufrmIndtastTekst in 'ufrmIndtastTekst.pas' {frmIndtastTekst},
  uBogfoerSettings in 'uBogfoerSettings.pas' {frmBogfoerSettings},
  frmUndo in 'frmUndo.pas' {fmUndo},
  LaserFormularer in '..\..\XE7\Apotek\Common\LaserFormularer.pas' {dmFormularer: TDataModule},
  EmailFakturau in '..\..\XE7\Apotek\Common\EmailFakturau.pas' {frmEmailFaktura},
  frmMidCli in '..\..\XE7\Apotek\Common\frmMidCli.pas' {MidCli};

{$R *.RES}

begin

  RPDefine.DataID := IntToStr(Application.Handle);
  Application.Initialize;
  if UpperCase(ExtractFileName( Application.ExeName)) = uppercase('Patientkartotek.exe') then
    Application.Title := 'Ekspedition'
  else
    Application.Title := 'Arkiv Ekspedition';
  ReportMemoryLeaksOnShutdown := False;
  Application.MainFormOnTaskBar := False;
  GotoPreviousInstance;
  Application.HelpFile := 'C2Help.Hlp';
  SplashScreenShow(Nil, 'Ekspedition', 'Initialiserer');
  Application.CreateForm(TMainLog, MainLog);
  Application.CreateForm(TMainDm, MainDm);
  Application.CreateForm(TDMDSPrinter, DMDSPrinter);
  Application.CreateForm(TSMSDM, SMSDM);
  Application.CreateForm(TMidClient, MidClient);
  Application.CreateForm(TdmFormularer, dmFormularer);
  Application.CreateForm(TStamForm, StamForm);
  Application.CreateForm(TMidCli, MidCli);
  Application.CreateForm(TPnLstForm, PnLstForm);
  Application.CreateForm(TYdLstForm, YdLstForm);
  Application.CreateForm(TfmCtrBevilling, fmCtrBevilling);
  Application.CreateForm(TTastaturForm, TastaturForm);
  Application.CreateForm(TDeLstForm, DeLstForm);
  Application.CreateForm(TBevillingsForm, BevillingsForm);
  Application.CreateForm(TfmUbi, fmUbi);
  Application.CreateForm(TSubstForm, SubstForm);
  Application.CreateForm(TfrmRetLin, frmRetLin);
  Application.CreateForm(TfrmRowaApp, frmRowaApp);
  Application.CreateForm(TRCPMidCli, RCPMidCli);
  Application.CreateForm(TPatMatrixPrnForm, PatMatrixPrnForm);
  Application.CreateForm(TfrmC2Q, frmC2Q);
  Application.CreateForm(TPrintForm, PrintForm);
  Application.CreateForm(TPrintDosCardDM, PrintDosCardDM);
  C2Splash.SplashScreenHide;
  Application.Run;
end.


