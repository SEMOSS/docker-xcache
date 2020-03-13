FROM semoss/docker:user

ENV  LD_LIBRARY_PATH=/home/semoss/OpenBLAS/lib:$LD_LIBRARY_PATH

RUN  sudo apt-get update \
	&& pip3 install swifter \
	&& pip3 install pyarrow \
	&& R -e "install.packages('fst', repos='http://cran.rstudio.com/')" \
	&& pip3 uninstall -y numpy \ 
	&& rm $SEMOSS_BASE/semosshome/RDF_Map.prop \
	&& cd $SEMOSS_BASE \
	&& git clone https://github.com/xianyi/OpenBLAS \
	&& cd OpenBLAS \
	&& sudo make FC=gfortran \
	&& sudo make PREFIX=/home/semoss/OpenBLAS install \
	&& sudo ldconfig \
	&& cd $SEMOSS_BASE \
	&& git clone https://github.com/numpy/numpy \
	&& cd numpy \
	&& git checkout maintenance/1.17.x
	
	
COPY site.cfg /home/semoss/numpy/site.cfg

RUN cd $SEMOSS_BASE/numpy \
	&& pip3 install Cython \
	&& pip3 install .

COPY RDF_Map.prop /home/semoss/semosshome/

RUN sudo sed -i '$ d' /etc/sudoers

WORKDIR /home/semoss

CMD ["start.sh"]
