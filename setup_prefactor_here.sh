#!/bin/bash

setup_dir=`pwd`

cp /usr/share/prefactor/pipeline.cfg .
mkdir runtime working log
sed -i -e "s%^runtime_directory = /SET/THIS/%runtime_directory = ${setup_dir}/runtime%" \
       -e "s%^working_directory = /SET/THIS/./USED/FOR/DATA%working_directory = ${setup_dir}/working%" \
       -e "s%/DESTINATION/OF/LOGFILES/log%${setup_dir}/log%" \
       pipeline.cfg

cp /usr/share/prefactor/parsets/Pre-Facet-Calibrator.parset .
mkdir cal_data_in cal_inspection cal_values
sed -i -e "s%/data/scratch/username/PathToYourCalibratorData/%${setup_dir}/cal_data_in/%" \
       -e "s%/media/scratch/test/username/WhereYouWantInspectionPlotsEtc/%${setup_dir}/cal_inspection/%" \
       -e "s%/media/scratch/test/username/WhereYouWantToStoreTheValuesFromTheCalibrator/%${setup_dir}/cal_values/%" \
       Pre-Facet-Calibrator.parset

cp /usr/share/prefactor/parsets/Pre-Facet-Target.parset .
mkdir target_data_in target_inspection target_data_out ionex
sed -i -e "s%/data/scratch/username/PathToYourTargetData/%${setup_dir}/target_data_in/%" \
       -e "s%/usr/share/prefactor/skymodels/PleaseProvideTarget.skymodel%${setup_dir}/Target.skymodel%" \
       -e "s%/media/scratch/test/username/WhereYouWantInspectionPlotsEtc/%${setup_dir}/target_inspection/%" \
       -e "s%/media/scratch/test/username/WhereYouWantToStoreTheValuesFromTheCalibrator/%${setup_dir}/cal_values/%" \
       -e "s%/media/scratch/test/username/WhereYouWantYourProcessedData/%${setup_dir}/target_data_out/%" \
       -e "s%ftp://ftp.unibe.ch/aiub/CODE/%ftp://ftp.aiub.unibe.ch/CODE/%" \
       -e "s%^! ionex_server  = None%! ionex_server  = ftp://ftp.aiub.unibe.ch/CODE/%" \
       -e "s%^! ionex_path    = .*%! ionex_path    = ${setup_dir}/ionex/%" \
       Pre-Facet-Target.parset

cp /usr/share/prefactor/parsets/Initial-Subtract.parset .
mkdir subtract_inspection scratch
sed -i -e "s%/data/scratch/username/PathToYourTargetData/%${setup_dir}/target_data_out/%" \
       -e "s%/media/scratch/test/username/WhereYouWantImagesAndInspectionPlots/%${setup_dir}/subtract_inspection/%" \
       -e "s%/local/username%${setup_dir}/scratch%" \
       Initial-Subtract.parset

cat << EOF > run.sh
#!/bin/bash

set -e

genericpipeline.py -v -d -c ${setup_dir}/pipeline.cfg ${setup_dir}/Pre-Facet-Calibrator.parset
genericpipeline.py -v -d -c ${setup_dir}/pipeline.cfg ${setup_dir}/Pre-Facet-Target.parset
genericpipeline.py -v -d -c ${setup_dir}/pipeline.cfg ${setup_dir}/Initial-Subtract.parset
EOF
