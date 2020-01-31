FROM semoss/docker:latest

ENV  LD_LIBRARY_PATH=/opt/OpenBLAS/lib:$LD_LIBRARY_PATH

RUN  apt-get update \
	&& pip3 install swifter \
	&& pip3 install pyarrow \
	&& R -e "install.packages('fst', repos='http://cran.rstudio.com/')" \
	&& pip3 uninstall -y numpy \ 
	&& rm /opt/semosshome/RDF_Map.prop \
	&& cd /opt \
	&& git clone https://github.com/xianyi/OpenBLAS \
	&& cd OpenBLAS \
	&& make FC=gfortran \
	&& make PREFIX=/opt/OpenBLAS install \
	&& ldconfig \
	&& cd /opt \
	&& git clone https://github.com/numpy/numpy \
	&& cd numpy \
	&& git checkout maintenance/1.17.x \
	&& pip3 install Cython 

COPY site.cfg /opt/numpy/site.cfg

RUN cd /opt/numpy \
	&& pip3 install .

COPY RDF_Map.prop /opt/semosshome/

WORKDIR /opt/semoss-artifacts/artifacts/scripts

CMD ["start.sh"]