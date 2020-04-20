# ElementUI

## 注意事项
   - element-ui select组件使用需要注意的
     + 当在使用select组件的时候，要注意
     ` <el-select v-model="scope.row.state"
                               @change="editDriftStatus"
                               placeholder="请选择">
            <el-option v-for="item in drifStatusOptions"
                                   :label="item.label"
                                   :value="item.value">
            </el-option>
        </el-select>`
       el-select  里面的v-model值要和el-option里面的value值对上，特别注意数据类型，之前value值写成字符串了，导致没效果      
