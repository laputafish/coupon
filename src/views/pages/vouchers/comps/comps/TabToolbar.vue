<template>
  <div class="toolbar d-flex justify-content-between mb-1">
    <div class="d-flex flex-row justify-content-end align-items-center">
      <h4 class="d-inline-block mr-2 my-0">
         <font-awesome-icon icon="search" />
      </h4>
      <form @submit.prevent="search()">
        <div class="form-group m-0 d-inline-block" style="">
          <div class="input-group">
            <input class="form-control" v-model="searchValue">
            <div class="input-group-append">
              <button type="button" @click="setSearchValue('')">
                <i class="fas fa-fw fa-times"></i>
              </button>
            </div>
          </div>
        </div>
      </form>
      <h3 v-if="appLoading" class="d-inline-block ml-3 my-0 mr-auto">
         <font-awesome-icon icon="spinner" class="fa-spin"/>
      </h3>
      <!--<div v-if="codeInfos.length>0" class="badge badge-warning">{{ codeInfos.length }}</div>-->
    </div>
    <div class="">

      <button type="button"
              :disabled="data.length===0"
              class="btn btn-danger min-width-100 mr-1"
              @click="deleteAll()">
        <i class="fas fa-times"></i>
        <span class="ml-2">{{ $t('buttons.deleteAll') }}</span>
      </button>
      <button type="button"
              :disabled="data.length===0"
              class="btn btn-warning min-width-100 mr-1"
              @click="exportExcel()">
        <i class="fas fa-times"></i>
        <span class="ml-2">{{ $t('buttons.export') }}</span>
      </button>
      <xls-file-upload
          inputId="uploadCodes"
          uploadUrl="/agent_codes/upload"
          :postData="{id: voucherId}"
          @onUploading="onUploadingHandler"
          @onUploaded="onUploadedHandler"></xls-file-upload>
      <!--<file-upload-->
      <!--extensions="xlsx"-->
      <!--accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"-->
      <!--name="file"-->
      <!--class="btn btn-primary"-->
      <!--:post-action="postAction"-->
      <!--:drop="!edit"-->
      <!--:data="{id: voucherId}"-->
      <!--:headers="authHeaders"-->
      <!--v-model="files"-->
      <!--@click="checkCodeExists"-->
      <!--@input-filter="inputFilter"-->
      <!--@input-file="inputFile"-->
      <!--ref="upload">-->
      <!--&lt;!&ndash;<font-awesome-icon v-if="uploading" icon="spinner" class="fa-spin" />&ndash;&gt;-->
      <!--<font-awesome-icon icon="file-import"></font-awesome-icon>-->
      <!--Upload File-->
      <!--</file-upload>-->
    </div>
  </div>
</template>