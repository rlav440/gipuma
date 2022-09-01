#!
prog='./gipuma'
warping='../fusibile/fusibile'
input_dir='data/synth_sphere/input_images/'
depth_dir='data/synth_sphere/input_depths/'
normal_dir='data/synth_sphere/input_norms/'
batch_name='synth_sphere'
output_dir_base="results/$batch_name"
p_folder="data/synth_sphere/sphere_par.txt"

base=$(pwd)
# Run parameters
scale=1
blocksize=11
iter=8
cost_gamma=10
cost_comb="best_n"
n_best=2
depth_max=0.8
depth_min=0.3
image_list_array=$( cd $input_dir && ls *.png)
cd $normal_dir || exit
norm_list_array=(*.png)
cd $base || exit
cd $depth_dir || exit
depth_list_array=(*.png)
output_dir=${output_dir_base}/

# fuse options
disp_thresh=0.5
normal_thresh=30
num_consistent=1
min_angle=5
max_angle=70

# options to run over all data
count=0
for im in $image_list_array; do
  echo $count #prints the count to the screen
  img=${im%.png}
  cmd_file=${output_dir}/$img-cmd.log
  image_list=($im) # makes a list starting with the im of interest

  mkdir -p $output_dir
  for ij in $image_list_array; do
    if [ $im != $ij ]; then
      image_list+=( $ij ) #appends the option to the list
    fi
  done

  depth_seed=${depth_list_array[$count]}
  normal_seed=${norm_list_array[$count]}

  cmd="$prog ${image_list[@]} -images_folder $input_dir -krt_file $p_folder -output_folder $output_dir --depth_seed=$depth_seed --normal_seed=$normal_seed --cam_scale=$scale --iterations=$iter --blocksize=$blocksize --cost_gamma=$cost_gamma --cost_comb=best_n --n_best=$n_best --depth_max=$depth_max --depth_min=$depth_min --min_angle=$min_angle --max_angle=$max_angle"
  echo $cmd
  #$cmd

  let "count += 1"
  if [ $count -eq -1 ]; then
    break
  fi
done