clear
CD=cd;
seg_directory=[cd '\BSDS300sorted\ground_truth\color\train\'];
mask_directory=[cd '\mask\color\train\'];
cd(seg_directory)
seg_filenames=dir([seg_directory '*.seg']);
cd(CD)
for i=1:length(seg_filenames)
    seg_filename=seg_filenames(i).name;
    mask_filename=[erase(seg_filename,'.seg') '.png'];
    make_mask([seg_directory seg_filename],[mask_directory mask_filename])
end
